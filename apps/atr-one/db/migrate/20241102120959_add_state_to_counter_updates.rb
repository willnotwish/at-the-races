class AddStateToCounterUpdates < ActiveRecord::Migration
  def change
    add_column :counter_updates, :aasm_state, :integer
    add_column :counter_updates, :allocated_at, :timestamp
    add_column :counter_updates, :processed_at, :timestamp
    add_column :counter_updates, :failed_at, :timestamp
  end
end
