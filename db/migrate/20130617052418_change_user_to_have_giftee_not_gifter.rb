class ChangeUserToHaveGifteeNotGifter < ActiveRecord::Migration
  def up
    add_column :users, :giftee_id, :integer
    User.all.each do |user|
      user.gifter.giftee_id = user.id
    end
    remove_column :users, :gifter_id
  end

  def down
    add_column :users, :gifter_id, :integer
    User.all.each do |user|
      user.giftee.gifter_id = user.id
    end
    remove_column :users, :giftee_id
  end
end
