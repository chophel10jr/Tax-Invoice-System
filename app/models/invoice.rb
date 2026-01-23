class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :created_by, class_name: "User"
  has_many :transactions, dependent: :restrict_with_error

  STATUSES = %w[draft issued cancelled].freeze

  validates :invoice_number, presence: true, uniqueness: true
  validates :status, inclusion: { in: STATUSES }
  validates :currency, presence: true

  def recalculate_totals!
    self.subtotal   = transactions.sum(:amount)
    self.tax_total  = transactions.sum(:tax_amount)
    self.grand_total = subtotal + tax_total
    save!
  end
end
