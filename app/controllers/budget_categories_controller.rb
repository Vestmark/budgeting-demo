class BudgetCategoriesController < ApplicationController
  before_action :require_authentication
  before_action :set_budget
  before_action :set_budget_category, only: [:update, :destroy]

  def create
    @budget_category = @budget.budget_categories.build(budget_category_params)
    
    if @budget_category.save
      redirect_to @budget, notice: "Category added to budget."
    else
      redirect_to @budget, alert: "Failed to add category to budget."
    end
  end

  def update
    if @budget_category.update(budget_category_params)
      redirect_to @budget, notice: "Budget category updated."
    else
      redirect_to @budget, alert: "Failed to update budget category."
    end
  end

  def destroy
    @budget_category.destroy
    redirect_to @budget, notice: "Category removed from budget."
  end

  private

  def set_budget
    @budget = current_user.budgets.find(params[:budget_id])
  end

  def set_budget_category
    @budget_category = @budget.budget_categories.find(params[:id])
  end

  def budget_category_params
    params.require(:budget_category).permit(:category_id, :amount)
  end
end