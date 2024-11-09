class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :company_name
      t.float :total_price
      t.float :stock_price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
