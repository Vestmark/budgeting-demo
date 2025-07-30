class DashboardController < ApplicationController
  before_action :require_authentication

  def index
    @current_month = Date.current
    @active_budgets = current_user.budgets.active
    @recent_transactions = current_user.transactions.recent.limit(10)
    @monthly_income = calculate_monthly_income
    @monthly_expenses = calculate_monthly_expenses
    @savings_rate = calculate_savings_rate
  end

  private

  def calculate_monthly_income
    current_user.transactions
                .income
                .for_month(@current_month)
                .sum(:amount)
  end

  def calculate_monthly_expenses
    current_user.transactions
                .expense
                .for_month(@current_month)
                .sum(:amount)
  end

  def calculate_savings_rate
    return 0 if @monthly_income.zero?
    (((@monthly_income - @monthly_expenses) / @monthly_income) * 100).round(2)
  end
end
