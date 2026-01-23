class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.references :customer, null: false, foreign_key: true
      t.date :issue_date, default: -> { "CURRENT_DATE" }
      t.string :status, default: "draft"
      t.string :currency, default: "BTN"
      t.decimal :subtotal
      t.decimal :tax_total
      t.decimal :grand_total
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
