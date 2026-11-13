class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :name
      t.integer :age

      t.timestamps
    end
  end
end
