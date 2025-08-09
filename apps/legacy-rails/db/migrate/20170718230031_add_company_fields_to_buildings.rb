class AddCompanyFieldsToBuildings < ActiveRecord::Migration

  def up
    change_table :buildings do |t|
      t.string :phone
      t.string :email
      t.string :website
      t.string :opening_hours
    end
  end

  def down
    change_table :buildings do |t|
      t.remove :phone, :email, :website, :opening_hours
    end
  end

end
