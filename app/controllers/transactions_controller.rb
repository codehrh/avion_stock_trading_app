class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions.order(created_at: :desc)
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)

    if @transaction.save
      flash[:notice] = "Transaction recorded successfully."
    else
      flash[:alert] = "Failed to record the transaction."
    end

    redirect_to transactions_path
  end

  private

  def transaction_params
    params.require(:transaction).permit(:company_name, :total_price, :stock_price, :action_type, :shares)
  end

end