class ChangeCostPriceDataTypeInStocks < ActiveRecord::Migration[7.2]
  def change
    change_column :stocks, :cost_price, :float
  end
end
