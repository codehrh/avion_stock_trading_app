class AddSymbolAndSharesToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :symbol, :string
    add_column :transactions, :shares, :integer
  end
end