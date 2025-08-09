class CreateMessagesUsers < ActiveRecord::Migration
  def change
    create_table :messages_users do |t|
      t.references :message, index: true
      t.references :user, index: true
    end
  end
end
