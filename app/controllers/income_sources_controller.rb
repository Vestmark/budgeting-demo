class IncomeSourcesController < ApplicationController
  before_action :require_authentication
  before_action :set_income_source, only: [:show, :edit, :update, :destroy]

  def index
    @active_income_sources = current_user.income_sources.active.includes(:category)
    @inactive_income_sources = current_user.income_sources.inactive.includes(:category)
  end

  def show
  end

  def new
    @income_source = current_user.income_sources.build(active: true, start_date: Date.current)
    @income_categories = current_user.categories.income.ordered
  end

  def create
    @income_source = current_user.income_sources.build(income_source_params)
    
    if @income_source.save
      redirect_to income_sources_path, notice: "Income source was successfully created."
    else
      @income_categories = current_user.categories.income.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @income_categories = current_user.categories.income.ordered
  end

  def update
    if @income_source.update(income_source_params)
      redirect_to income_sources_path, notice: "Income source was successfully updated."
    else
      @income_categories = current_user.categories.income.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @income_source.destroy
    redirect_to income_sources_url, notice: "Income source was successfully deleted."
  end

  private

  def set_income_source
    @income_source = current_user.income_sources.find(params[:id])
  end

  def income_source_params
    params.require(:income_source).permit(:name, :amount, :frequency, :category_id, :start_date, :end_date, :active)
  end
end