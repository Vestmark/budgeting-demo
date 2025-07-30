class Category < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :transactions, dependent: :restrict_with_error

  enum :category_type, { expense: 0, income: 1 }

  validates :name, presence: true
  validates :category_type, presence: true
  validate :prevent_parent_self_reference

  scope :root_categories, -> { where(parent_id: nil) }
  scope :ordered, -> { order(:position, :name) }

  PREDEFINED_EXPENSE_CATEGORIES = [
    { name: "Housing", icon: "🏠", color: "#4A5568" },
    { name: "Transportation", icon: "🚗", color: "#3182CE" },
    { name: "Food", icon: "🍔", color: "#38A169" },
    { name: "Entertainment", icon: "🎮", color: "#D69E2E" },
    { name: "Healthcare", icon: "🏥", color: "#E53E3E" },
    { name: "Personal", icon: "👤", color: "#805AD5" },
    { name: "Savings & Investments", icon: "💰", color: "#2D3748" },
    { name: "Debt Payments", icon: "💳", color: "#E53E3E" },
    { name: "Miscellaneous", icon: "📦", color: "#718096" }
  ].freeze

  PREDEFINED_INCOME_CATEGORIES = [
    { name: "Salary", icon: "💼", color: "#38A169" },
    { name: "Freelance", icon: "💻", color: "#3182CE" },
    { name: "Investments", icon: "📈", color: "#805AD5" },
    { name: "Other Income", icon: "💵", color: "#718096" }
  ].freeze

  private

  def prevent_parent_self_reference
    errors.add(:parent_id, "can't be self") if parent_id.present? && parent_id == id
  end
end
