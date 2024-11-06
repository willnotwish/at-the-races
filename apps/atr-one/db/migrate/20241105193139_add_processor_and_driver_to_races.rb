class AddProcessorAndDriverToRaces < ActiveRecord::Migration
  def change
    add_column :races, :processor, :string
    add_column :races, :driver, :string
  end
end
