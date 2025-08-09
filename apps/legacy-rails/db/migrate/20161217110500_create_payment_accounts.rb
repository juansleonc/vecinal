class CreatePaymentAccounts < ActiveRecord::Migration
  def change
    create_table :payment_accounts do |t|
      t.references  :building, index: true, unique: true
      t.string      :status
      t.string      :bank_name
      t.string      :account_name
      t.string      :account_number
      t.string      :account_type
      t.string      :transit_number
      t.string      :institution_number
      t.string      :routing_number
      t.boolean     :enable_payments
      t.string      :cust_id_cliente
      t.string      :public_key
      t.string      :country

      t.timestamps
    end
  end
end
