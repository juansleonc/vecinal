class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.references :publisher
      t.references :building
      t.string :question
      t.datetime :end_date

      t.timestamps
    end
  end
end
