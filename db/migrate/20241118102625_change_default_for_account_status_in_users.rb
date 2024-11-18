class ChangeDefaultForAccountStatusInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :account_status, "pending"
  end
end
