class User < ActiveRecord::Base
  
  belongs_to :event, inverse_of: :users

  attr_accessible :name

  validates :name, presence: true, length: { maximum: 400 }
  validates :event, presence: true
end
