class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :company_name
      t.integer :shares, default: 0
      t.decimal :cost_price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
