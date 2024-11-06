class AddRaceResultToCounterUpdates < ActiveRecord::Migration
  def change
    add_reference :counter_updates, :race_result, index: true, foreign_key: true
    add_column :counter_updates, :processed_by, :string
  end
end
