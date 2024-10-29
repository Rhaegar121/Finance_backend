class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.date :date
      t.decimal :amount
      t.string :description
      t.string :category
      t.boolean :income

      t.timestamps
    end
  end
end
