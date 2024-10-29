class CreateCounters < ActiveRecord::Migration
  def change
    create_table :counters do |t|
      t.string :code
      t.integer :value, default: 0
      t.references :month, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
