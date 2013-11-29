class AddAdminUidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :admin_uid, :string
  end
end
