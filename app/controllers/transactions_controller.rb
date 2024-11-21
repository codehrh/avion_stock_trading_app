class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions.order(created_at: :desc)
  end

  def create
    redirect_to transactions_path
  end

  def portfolio
    @transactions = current_user.transactions.order(created_at: :desc)
    # Calculate total shares owned (sum of all shares for the user)
    @total_shares = @transactions.sum(:shares)

    # Group by symbol and calculate total shares and cost price
    @portfolio_summary = current_user.transactions
    .select('symbol, SUM(shares) AS total_shares, SUM(total_price) AS total_cost_price')
    .group(:symbol)
    .order('symbol ASC') # Optional: Order by symbol alphabetically
    end

  end