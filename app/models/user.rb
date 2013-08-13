class User < ActiveRecord::Base
  
  belongs_to :event, inverse_of: :users

  belongs_to :gifter, class_name: "User", foreign_key: "giftee_id"
  has_one :giftee, class_name: "User", foreign_key: "giftee_id"

  validates :name, presence: true, length: { maximum: 400 }
  validates :event, presence: true
  validate :giftee_same_event, if: lambda { giftee.present? }

  private

    def giftee_same_event
      if event != giftee.event
        errors.add(:giftee, "must belong to the same event")
      end
    end

end
