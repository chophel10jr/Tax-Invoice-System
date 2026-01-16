class Invoice < ApplicationRecord
  # Associations
  belongs_to :customer
  has_many :transactions, dependent: :restrict_with_error

  # Statuses (simple, string-based)
  STATUSES = %w[issued cancelled].freeze

  # Validations
  validates :invoice_number, presence: true, uniqueness: true
  validates :status, inclusion: { in: STATUSES }
  validates :currency, presence: true

  # Callbacks
  before_validation :set_defaults, on: :create

  # Public API
  def recalculate_totals!
    self.subtotal   = transactions.sum(:amount)
    self.tax_total  = transactions.sum(:tax_amount)
    self.grand_total = subtotal + tax_total
    save!
  end

  private

  def set_defaults
    self.status   ||= "issued"
    self.currency ||= "BTN"
    self.issue_date ||= Date.today
  end
end
