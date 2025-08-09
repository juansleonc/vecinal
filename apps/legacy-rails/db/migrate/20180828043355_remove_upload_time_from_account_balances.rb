class RemoveUploadTimeFromAccountBalances < ActiveRecord::Migration
  def change
    remove_column :account_balances, :upload_time
  end
end
