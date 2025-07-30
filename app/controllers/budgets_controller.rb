class BudgetsController < ApplicationController
  before_action :require_authentication
  before_action :set_budget, only: [:show, :edit, :update, :destroy]

  def index
    @budgets = current_user.budgets.includes(:categories)
    @active_budgets = @budgets.active
    @upcoming_budgets = @budgets.upcoming
    @past_budgets = @budgets.past
  end

  def show
    @budget_categories = @budget.budget_categories.includes(:category)
    @transactions = current_user.transactions
                               .joins(:category)
                               .where(category: @budget.categories)
                               .where(date: @budget.date_range)
                               .recent
  end

  def new
    @budget = current_user.budgets.build
    @categories = current_user.categories.expense.ordered
  end

  def create
    @budget = current_user.budgets.build(budget_params)
    
    if @budget.save
      # Handle category allocations
      if params[:budget][:category_allocations].present?
        params[:budget][:category_allocations].each do |category_id, amount|
          next if amount.blank? || amount.to_f == 0
          @budget.budget_categories.create!(
            category_id: category_id,
            amount: amount
          )
        end
      end
      
      redirect_to @budget, notice: "Budget was successfully created."
    else
      @categories = current_user.categories.expense.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = current_user.categories.expense.ordered
  end

  def update
    if @budget.update(budget_params)
      redirect_to @budget, notice: "Budget was successfully updated."
    else
      @categories = current_user.categories.expense.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget.destroy
    redirect_to budgets_url, notice: "Budget was successfully deleted."
  end

  private

  def set_budget
    @budget = current_user.budgets.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:name, :budget_type, :amount, :start_date, :end_date,
                                   budget_categories_attributes: [:id, :category_id, :amount, :_destroy])
  end
end