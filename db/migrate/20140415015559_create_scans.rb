class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.belongs_to :user, null: false
      t.string :targets, null: false
      t.string :uuid
      t.text :raw_result
      t.timestamps
    end

    add_index :scans, :uuid, unique: true
    add_index :scans, :targets, unique: true
  end
end
