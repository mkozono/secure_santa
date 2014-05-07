require 'secure_santa/assigner'

class Event < ActiveRecord::Base

  has_many :players, inverse_of: :event, dependent: :destroy

  validates :name, presence: true, length: { maximum: 300 }
  validates :players, :nested_attributes_uniqueness => {:field => :name}

  accepts_nested_attributes_for :players, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  before_create :set_admin_uid

  def assign_giftees
    assigner = SecureSanta::Assigner.new players.to_a
    assignments = assigner.assign_giftees
    assignments.each do |player, giftee|
      player.update_attributes!(:giftee_id => giftee.id)
    end
  end

  def assigned?
    players.each do |player|
      return false if player.gifter.blank?
    end
    true
  end

  def players_claimed?
    players.all? { |p| p.claimed? }
  end

  def destroy_players!(players_attributes)
    return true unless players_attributes

    # Must destroy any players marked for destruction before other updates to avoid complicated validations
    destroy_keys = []
    players_attributes.each do |k, player_params|
      if ["true", "1"].include? player_params["_destroy"]
        player = Player.where(:id => player_params["id"]).last
        if player && player.event_id == self.id
          destroy_keys << k
          player.destroy
        end
      end
    end

    players_attributes.delete_if { |k| destroy_keys.include? k }

    true
  end

  def create_or_update_players(players_attributes)
    return true unless players_attributes

    players_attributes.each do |k, player_params|
      player = Player.where(:id => player_params["id"]).last
      if player_params && player_params["name"].present?
        if player
          raise "Cannot update a player of a different event!" if player.event_id != self.id
          # Update
          player.name = player_params["name"].strip
          player.save!
        else
          # Create
          Player.create!(:event => self, :name => player_params["name"].strip)
        end
      end
    end

    true
  end

  def set_admin_uid
    self.admin_uid = unique_admin_uid(10000000)
  end

  def unique_admin_uid(max_uid)
    all_uids = self.class.pluck(:admin_uid)
    tries = 10000
    digits = (max_uid - 1).to_s.size
    temp_uid = nil
    until (temp_uid && !all_uids.include?(temp_uid))
      temp_uid = rand(max_uid).to_s.rjust(digits, "0")
      tries -= 1
      if tries <= 0
        raise StandardError, "Too many events for UID range"
      end
    end
    temp_uid
  end

end
