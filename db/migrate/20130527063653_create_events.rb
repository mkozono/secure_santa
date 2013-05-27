class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, limit: 300

      t.timestamps
    end
  end
end
