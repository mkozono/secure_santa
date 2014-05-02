class RenameUsersToPlayers < ActiveRecord::Migration
  def change
    rename_table :users, :players
  end
end
