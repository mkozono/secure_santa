require 'secure_santa/assigner'

class Event < ActiveRecord::Base

  has_many :users, inverse_of: :event, dependent: :destroy

  attr_accessible :name, :users_attributes

  validates :name, presence: true, length: { maximum: 300 }

  accepts_nested_attributes_for :users, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  def assign_giftees
    assigner = SecureSanta::Assigner.new users
    assignments = assigner.assign_giftees
    assignments.each do |user, giftee|
      user.giftee = giftee
    end
  end

end
