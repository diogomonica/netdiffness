class CreateScanResults < ActiveRecord::Migration
  def change
    create_table :scan_results do |t|
      t.belongs_to :scan, null: false
      t.text :raw_result, limit: 4294967295
      t.string :uuid
      t.boolean :finished, null:false, default: false
      t.timestamps
    end
  add_index :scan_results, :uuid, unique: true
  end
end
