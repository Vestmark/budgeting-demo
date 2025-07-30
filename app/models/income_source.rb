class IncomeSource < ApplicationRecord
  belongs_to :user
  belongs_to :category

  enum :frequency, { weekly: 0, biweekly: 1, monthly: 2, quarterly: 3, annually: 4, one_time: 5 }

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :frequency, presence: true
  validates :start_date, presence: true
  validate :end_date_after_start_date
  validate :category_must_be_income

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def expected_income_for_period(start_date, end_date)
    return 0 unless active? && self.start_date <= end_date && (self.end_date.nil? || self.end_date >= start_date)

    case frequency
    when "weekly"
      ((end_date - start_date).to_i / 7.0).ceil * amount
    when "biweekly"
      ((end_date - start_date).to_i / 14.0).ceil * amount
    when "monthly"
      months_between(start_date, end_date) * amount
    when "quarterly"
      (months_between(start_date, end_date) / 3.0).ceil * amount
    when "annually"
      years_between(start_date, end_date) * amount
    when "one_time"
      (self.start_date >= start_date && self.start_date <= end_date) ? amount : 0
    else
      0
    end
  end

  private

  def end_date_after_start_date
    return unless start_date.present? && end_date.present?
    errors.add(:end_date, "must be after start date") if end_date < start_date
  end

  def category_must_be_income
    return unless category.present?
    errors.add(:category, "must be an income category") unless category.income?
  end

  def months_between(start_date, end_date)
    ((end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month) + 1).abs
  end

  def years_between(start_date, end_date)
    (end_date.year - start_date.year + 1).abs
  end
end
