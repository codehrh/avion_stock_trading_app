class ChangeDefaultForAdminInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :admin, true
  end
end