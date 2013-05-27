class User < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, length: { maximum: 300 }
end
