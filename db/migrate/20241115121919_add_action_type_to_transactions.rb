class AddActionTypeToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :action_type, :string
  end
end
