require 'secure_santa/assigner'

class Event < ActiveRecord::Base

  attr_accessor :date_month, :date_day, :date_year
  has_many :players, inverse_of: :event, dependent: :destroy

  validates :name, presence: true, length: { maximum: 300 }
  validates :players, :nested_attributes_uniqueness => {:field => :name}
  validate :valid_temporary_date_fields, if: :temporary_date_fields?

  accepts_nested_attributes_for :players, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  before_save :set_date_from_temporary_fields, if: :temporary_date_fields?
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

  def set_temporary_date_fields
    if date
      self.date_month = date.month
      self.date_day = date.day
      self.date_year = date.year % 100
    end
  end

  def temporary_date_fields?
    date_month.present? && date_day.present? && date_year.present?
  end

  def set_date_from_temporary_fields
    self.date = construct_date
  end

  def construct_date
    Date.new(date_year.to_i + 2000, date_month.to_i, date_day.to_i)
  end

  def valid_temporary_date_fields
    new_date = construct_date
    if date != new_date
      if new_date < 1.day.ago
        errors[:date] = "is too old"
      elsif new_date > 3.years.from_now
        errors[:date] = "is too far away"
      end
    end
  rescue ArgumentError => e
    errors[:date] = "is invalid"
  end

end
