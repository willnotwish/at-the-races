class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.string :name
      t.string :code

      t.timestamps null: false
    end
    add_index :months, :code
  end
end
