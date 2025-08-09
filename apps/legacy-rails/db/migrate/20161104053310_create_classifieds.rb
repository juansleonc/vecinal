class CreateClassifieds < ActiveRecord::Migration
  def change
    create_table :classifieds do |t|
      t.string      :title
      t.decimal     :price, precision: 11, scale: 2
      t.text        :description
      t.references  :publisher
      t.references  :building

      t.timestamps
    end
  end
end
