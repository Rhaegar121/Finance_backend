class AddIndexToDateInTransactions < ActiveRecord::Migration[7.0]
  def change
    add_index :transactions, :date
  end
end
