require 'secure_santa/assigner'

class Event < ActiveRecord::Base

  has_many :users, inverse_of: :event, dependent: :destroy

  validates :name, presence: true, length: { maximum: 300 }

  accepts_nested_attributes_for :users, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  def assign_giftees
    assigner = SecureSanta::Assigner.new users.to_a
    assignments = assigner.assign_giftees
    assignments.each do |user, giftee|
      user.giftee = giftee
    end
  end

  def assigned?
    users.each do |user|
      return false if user.gifter.blank?
    end
    true
  end

end
