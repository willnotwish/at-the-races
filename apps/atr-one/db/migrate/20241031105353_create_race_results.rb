class CreateRaceResults < ActiveRecord::Migration
  def change
    create_table :race_results do |t|
      t.references :race, index: true, foreign_key: true
      t.timestamp :started_at
      t.float :duration
      t.integer :counter_count

      t.timestamps null: false
    end
  end
end
