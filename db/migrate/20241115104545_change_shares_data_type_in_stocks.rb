class ChangeSharesDataTypeInStocks < ActiveRecord::Migration[7.2]
  def change
    change_column :stocks, :shares, :float, default: 0
  end
end
