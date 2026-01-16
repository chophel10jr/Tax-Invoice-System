class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :external_customer_id
      t.string :name
      t.string :email
      t.string :phone
      t.string :tax_number
      t.text :address
      t.string :cid

      t.timestamps
    end
  end
end
