class User < ApplicationRecord
  has_secure_password

  has_many :categories, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :income_sources, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  before_save :downcase_email
  after_create :create_default_categories

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_default_categories
    Category::PREDEFINED_EXPENSE_CATEGORIES.each_with_index do |cat, index|
      categories.create!(
        name: cat[:name],
        icon: cat[:icon],
        color: cat[:color],
        category_type: :expense,
        position: index
      )
    end

    Category::PREDEFINED_INCOME_CATEGORIES.each_with_index do |cat, index|
      categories.create!(
        name: cat[:name],
        icon: cat[:icon],
        color: cat[:color],
        category_type: :income,
        position: index
      )
    end
  end
end
