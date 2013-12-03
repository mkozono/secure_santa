class ChangeMessageToTextOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :message, :text
  end
  def down
    # Truncate to 255
    User.all.find_each do |user|
      if user.message && user.message.size > 255
        user.update_attributes!(:message => user.message[0, 255])
      end
    end

    change_column :users, :message, :string, :limit => 255
  end
end
