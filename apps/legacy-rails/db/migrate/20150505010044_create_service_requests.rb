class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.references :user, index: true
      t.references :responsible, polymorphic: true, index: true
      t.string :title
      t.text :content
      t.boolean :urgent
      t.string :category
      t.string :status

      t.timestamps
    end
  end
end
