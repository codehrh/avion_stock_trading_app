class ChangeDefaultForTotalPriceInTransactions < ActiveRecord::Migration[7.2]
  def change
    change_column_default :transactions, :total_price, 0.0
  end
end
