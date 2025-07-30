class TransactionsController < ApplicationController
  before_action :require_authentication
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = current_user.transactions.includes(:category).recent
    @transactions = @transactions.where(transaction_type: params[:type]) if params[:type].present?
  end

  def show
  end

  def new
    @transaction = current_user.transactions.build(
      date: Date.current,
      transaction_type: params[:type] || 'expense'
    )
    @categories = current_user.categories.where(category_type: @transaction.transaction_type).ordered
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)
    
    if @transaction.save
      redirect_to transactions_path, notice: "Transaction was successfully created."
    else
      @categories = current_user.categories.where(category_type: @transaction.transaction_type).ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = current_user.categories.where(category_type: @transaction.transaction_type).ordered
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: "Transaction was successfully updated."
    else
      @categories = current_user.categories.where(category_type: @transaction.transaction_type).ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: "Transaction was successfully deleted."
  end

  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :description, :date, :transaction_type, :category_id, :notes)
  end
end
