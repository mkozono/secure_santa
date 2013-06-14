class AddGifterIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gifter_id, :integer
  end
end
