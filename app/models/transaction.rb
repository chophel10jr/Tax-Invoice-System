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
  before_update :prevent_update_if_invoice_issued

  private

  def update_invoice_totals
    invoice.recalculate_totals!
  end

  def prevent_update_if_invoice_issued
    if invoice.status == "issued"
      errors.add(:base, "Cannot modify transactions of an issued invoice")
      throw :abort
    end
  end
end
# currency, :integer, default: BTN, null: false
