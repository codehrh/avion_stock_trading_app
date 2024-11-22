class PortfoliosController < ApplicationController

  def show
    @stocks = Stock.where(user_id: current_user.id).order(symbol: :asc)

    @total_shares = @stocks.sum(:shares)

    @portfolio_summary = @stocks
  end
end
