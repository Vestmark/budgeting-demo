class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category

  enum :transaction_type, { expense: 0, income: 1 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :transaction_type, presence: true
  validate :category_matches_transaction_type

  scope :recent, -> { order(date: :desc, created_at: :desc) }
  scope :for_month, ->(date) { where(date: date.beginning_of_month..date.end_of_month) }
  scope :for_year, ->(date) { where(date: date.beginning_of_year..date.end_of_year) }

  private

  def category_matches_transaction_type
    return unless category.present? && transaction_type.present?
    
    if expense? && category.income?
      errors.add(:category, "must be an expense category for expense transactions")
    elsif income? && category.expense?
      errors.add(:category, "must be an income category for income transactions")
    end
  end
end
