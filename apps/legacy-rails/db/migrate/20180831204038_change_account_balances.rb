class ChangeAccountBalances < ActiveRecord::Migration
  def change
    rename_column :account_balances, :pulication_date, :publication_date
  end
end
