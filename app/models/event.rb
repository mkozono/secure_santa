require 'secure_santa/assigner'

class Event < ActiveRecord::Base

  has_many :users, inverse_of: :event, dependent: :destroy

  validates :name, presence: true, length: { maximum: 300 }

  validates :users, :nested_attributes_uniqueness => {:field => :name}

  accepts_nested_attributes_for :users, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  def assign_giftees
    assigner = SecureSanta::Assigner.new users.to_a
    assignments = assigner.assign_giftees
    assignments.each do |user, giftee|
      user.update_attributes!(:giftee_id => giftee.id)
    end
  end

  def assigned?
    users.each do |user|
      return false if user.gifter.blank?
    end
    true
  end

  def update_users(params)
    users_attributes = params["users_attributes"]
    return true unless users_attributes
    # Must destroy any users marked for destruction before other updates to avoid complicated validations
    destroy_ids = []
    users_attributes.each do |k, user_params|
      if ["true", "1"].include? user_params["_destroy"]
        user = User.where(:id => user_params["id"]).last
        if user && user.event_id == self.id
          destroy_ids << user_params["id"]
          user.destroy
        end
      end
    end

    users_attributes.each do |k, user_params|
      unless destroy_ids.include?(user_params["id"])
        user = User.where(:id => user_params["id"]).last
        if user
          raise "Cannot update a user of a different event!" if user.event_id != self.id
          # Update
          user.name = user_params["name"]
          user.save!
        else
          # Create
          User.create!(:event => self, :name => user_params["name"])
        end
      end
    end

    true
  end

end
