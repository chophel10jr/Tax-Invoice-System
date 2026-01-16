class Transaction < ApplicationRecord
  # Associations
  belongs_to :invoice
  belongs_to :customer

  # Validations
  validates :external_transaction_ref, presence: true, uniqueness: true
  validates :transaction_date, presence: true
  validates :amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :tax_amount, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  after_commit :update_invoice_totals, on: [:create, :update, :destroy]

  private

  def update_invoice_totals
    invoice.recalculate_totals!
  end
end
# currency, :integer, default: BTN, null: false
