class Customer < ApplicationRecord
  # Associations
  has_many :invoices, dependent: :restrict_with_error
  has_many :transactions, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true
  validates :external_customer_id, presence: true, uniqueness: true

  # Optional but useful
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
