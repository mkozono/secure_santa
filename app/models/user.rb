class User < ActiveRecord::Base

  ROLE_ANONYMOUS = :anonymous
  ROLE_EVENT_ADMIN = :event_admin
  ROLE_SITE_ADMIN = :site_admin
  
  belongs_to :event, inverse_of: :users

  belongs_to :gifter, class_name: "User", foreign_key: "giftee_id"
  has_one :giftee, class_name: "User", foreign_key: "giftee_id"

  validates :name, presence: true, length: { maximum: 400 }
  validates :event, presence: true
  validate :giftee_same_event, if: lambda { giftee.present? }
  validates_uniqueness_of :name, scope: :event_id, message: "cannot be the same as another user in the event."

  def set_uid
    self.uid = unique_uid(10000000)
  end

  def unique_uid(max_uid)
    all_uids = self.class.pluck(:uid)
    tries = 10000
    digits = (max_uid - 1).to_s.size
    temp_uid = nil
    until (temp_uid && !all_uids.include?(temp_uid))
      temp_uid = rand(max_uid).to_s.rjust(digits, "0")
      tries -= 1
      if tries <= 0
        raise StandardError, "Too many users for UID range"
      end
    end
    temp_uid
  end

  private

    def giftee_same_event
      if event != giftee.event
        errors.add(:giftee, "must belong to the same event")
      end
    end

end
