class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :fax, :string
    add_column :companies, :opening_hours, :string
    add_column :companies, :website, :string
    add_column :companies, :description, :text
  end
end
