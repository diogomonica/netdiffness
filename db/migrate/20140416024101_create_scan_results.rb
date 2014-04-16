class CreateScanResults < ActiveRecord::Migration
  def change
    create_table :scan_results do |t|
      t.belongs_to :scan, null: false
      t.text :raw_result
      t.string :uuid
      t.timestamps
    end
  add_index :scan_results, :uuid, unique: true
  end
end
