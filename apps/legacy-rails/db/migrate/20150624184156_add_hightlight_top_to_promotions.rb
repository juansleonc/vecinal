class AddHightlightTopToPromotions < ActiveRecord::Migration
  def change
    change_table :promotions do |t|
      t.datetime :highlight
      t.datetime :top
      t.string :stripe_highlight_charge
      t.string :stripe_top_charge
    end
  end
end
