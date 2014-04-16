class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.belongs_to :user, null: false
      t.string :targets, null: false
      t.integer :frequency, null: false, default: 1440
      t.timestamps
    end

    add_index :scans, :targets, unique: false
  end
end
