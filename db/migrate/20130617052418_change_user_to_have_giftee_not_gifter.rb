class ChangeUserToHaveGifteeNotGifter < ActiveRecord::Migration
  def up
    add_column :users, :giftee_id, :integer
    # Reassign by giftee instead of gifter
    execute <<-SQL
      update users set giftee_id = (
        select id from users u
        where u.gifter_id = users.id
        )
    SQL
    remove_column :users, :gifter_id
  end

  def down
    add_column :users, :gifter_id, :integer
    # Reassign by gifter instead of giftee
    execute <<-SQL
      update users set gifter_id = (
        select id from users u
        where u.giftee_id = users.id
        )
    SQL
    remove_column :users, :giftee_id
  end
end
