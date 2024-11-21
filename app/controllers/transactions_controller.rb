class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions.order(created_at: :desc)
  end

  # def intraday
  #     if params[:symbol].present?
  #     api = AlphaVantageApi.new
    
  #     @intraday_data = api.time_series_intraday(params[:symbol])
  #     @stock_symbol = @intraday_data['Meta Data']['2. Symbol']
  #     @latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open')
  #     @stocks = Stock.where(symbol: params[:symbol], user_id: current_user.id)
  #     @stock_shares = @stocks.pluck(:shares).sum
  #     @stock_total_amount = @stocks.pluck(:cost_price).sum
  #     end
  #   end
  

  def create
    redirect_to transactions_path
  end
end