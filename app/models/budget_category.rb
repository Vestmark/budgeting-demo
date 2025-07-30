class BudgetCategory < ApplicationRecord
  belongs_to :budget
  belongs_to :category

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category_id, uniqueness: { scope: :budget_id }
end
