class User < ActiveRecord::Base
  
  belongs_to :event

  attr_accessible :name, :event_id

  validates :name, presence: true, length: { maximum: 400 }

end
