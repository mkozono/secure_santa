class AddEventIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :event_id, :integer, :null => false
  end
end
