class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true
      t.references :payment_account, index: true
      t.integer :cust_id_cliente
      t.string :description
      t.decimal :amount_ok, precision: 11, scale: 2
      t.decimal :amount_base, precision: 11, scale: 2
      t.integer :tax
      t.decimal :service_fee, precision: 8, scale: 2
      t.string :id_invoice
      t.string :currency_code, limit: 3
      t.string :bank_name
      t.string :cardnumber
      t.string :business
      t.integer :instalment
      t.string :franchise
      t.datetime :transaction_date
      t.integer :approval_code
      t.integer :transaction_id
      t.string :response
      t.string :errorcode
      t.string :customer_doctype, limit: 10
      t.string :customer_document
      t.string :customer_name
      t.string :customer_lastname
      t.string :customer_email
      t.string :customer_phone
      t.string :customer_country, limit: 3
      t.string :customer_city
      t.string :customer_address
      t.string :customer_ip, limit: 16
      t.decimal :amount_country, precision: 11, scale: 2
      t.decimal :amount, precision: 11, scale: 2
      t.integer :cod_response, limit: 1
      t.string :response_reason_text
      t.string :signature

      t.timestamps
    end
  end
end
