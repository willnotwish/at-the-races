class CreateCounterUpdates < ActiveRecord::Migration
  def change
    create_table :counter_updates do |t|
      t.string :counter_code, nil: false
      t.string :month_code, nil: false
      t.integer :value, nil: false

      t.timestamps null: false
    end
  end
end
