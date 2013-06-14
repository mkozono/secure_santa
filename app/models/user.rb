class User < ActiveRecord::Base
  
  belongs_to :event, inverse_of: :users

  has_one :giftee, :class_name => "User", :foreign_key => "gifter_id"
  belongs_to :gifter, :class_name => "User"

  attr_accessible :name

  validates :name, presence: true, length: { maximum: 400 }
  validates :event, presence: true
end
