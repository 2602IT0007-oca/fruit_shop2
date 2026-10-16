class AddAdminFlgToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :admin_flg, :boolean
  end
end
