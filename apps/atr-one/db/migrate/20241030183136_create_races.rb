class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.text :description
      t.integer :race_delay
      t.integer :thread_count
      t.integer :lock_timeout
      t.integer :update_count
      t.string :month_code
      t.string :counter_code

      t.timestamps null: false
    end
  end
end
