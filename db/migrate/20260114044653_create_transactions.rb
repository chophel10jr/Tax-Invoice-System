class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :external_transaction_ref
      t.references :invoice, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.date :transaction_date
      t.decimal :amount
      t.decimal :tax_amount
      t.string :currency

      t.timestamps
    end
  end
end
