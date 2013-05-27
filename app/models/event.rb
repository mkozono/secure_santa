class Event < ActiveRecord::Base
  attr_accessible :name
  has_many :users

  validates :name, presence: true, length: { maximum: 300 }
end
