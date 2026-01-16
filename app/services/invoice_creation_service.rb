class InvoiceCreationService < ApplicationService
  attr_accessor :rows

  def run
    validate_same_customer!

    ActiveRecord::Base.transaction do
      customer = find_or_create_customer(rows.first)
      invoice  = create_invoice(customer)
      transactions = create_transactions(invoice)

      {
        status: "success",
        customer_id: customer.id,
        invoice_id: invoice.id,
        invoice_number: invoice.invoice_number,
        transactions_created: transactions.count
      }
    end
  end

  private

  def validate_same_customer!
    customer_ids = rows.map { |r| r["RELATED_CUSTOMER"] }.uniq
    if customer_ids.size > 1
      raise StandardError, "All transactions must belong to the same customer. Found: #{customer_ids.join(', ')}"
    end
  end

  def find_or_create_customer(first_row)
    Customer.find_or_create_by!(external_customer_id: first_row["RELATED_CUSTOMER"]) do |c|
      c.name    = first_row["CUSTOMER_NAME1"]
      c.address = first_row["ADDRESS"]
      c.tax_number = first_row["TAX_ID"]
    end
  end

  def create_invoice(customer)
    unique_invoice_number = generate_invoice_number
    Invoice.create!(
      customer: customer,
      invoice_number: unique_invoice_number,
      issue_date: Time.current
    )
  end

  def create_transactions(invoice)
    rows.map do |row|
      Transaction.create!(
        invoice: invoice,
        customer: invoice.customer,
        external_transaction_ref: row["TRN_REF_NO"],
        transaction_date: row["TRN_DT"],
        tax_amount: row["LCY_AMOUNT"]
      )
    end
  end

  def generate_invoice_number
    "INV#{Time.current.strftime('%Y%m%d%H%M%S')}#{rand(1000..9999)}"
  end
end
