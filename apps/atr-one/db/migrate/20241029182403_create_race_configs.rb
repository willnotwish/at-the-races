class CreateRaceConfigs < ActiveRecord::Migration
  def change
    create_table :race_configs do |t|
      t.string :name
      t.text :description
      t.integer :thread_count
      t.integer :race_delay
      t.integer :lock_timeout

      t.timestamps null: false
    end
  end
end
