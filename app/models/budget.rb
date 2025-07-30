class Budget < ApplicationRecord
  belongs_to :user
  has_many :budget_categories, dependent: :destroy
  has_many :categories, through: :budget_categories

  accepts_nested_attributes_for :budget_categories, allow_destroy: true, reject_if: :all_blank

  enum :budget_type, { monthly: 0, goal_based: 1, annual: 2 }

  validates :name, presence: true
  validates :budget_type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validate :end_date_after_start_date

  scope :active, -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.current, Date.current) }
  scope :upcoming, -> { where("start_date > ?", Date.current) }
  scope :past, -> { where("end_date < ?", Date.current) }

  def active?
    start_date <= Date.current && (end_date.nil? || end_date >= Date.current)
  end

  def total_spent
    @total_spent ||= user.transactions
                         .joins(:category)
                         .where(category: categories)
                         .where(transaction_type: :expense)
                         .where(date: date_range)
                         .sum(:amount)
  end

  def remaining_amount
    amount - total_spent
  end

  def percentage_used
    return 0 if amount.zero?
    ((total_spent / amount) * 100).round(2)
  end

  def date_range
    case budget_type
    when "monthly"
      start_date.beginning_of_month..start_date.end_of_month
    when "annual"
      start_date.beginning_of_year..start_date.end_of_year
    else
      start_date..(end_date || Date.current)
    end
  end

  private

  def end_date_after_start_date
    return unless start_date.present? && end_date.present?
    errors.add(:end_date, "must be after start date") if end_date < start_date
  end
end
