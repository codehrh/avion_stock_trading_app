class StocksController < ApplicationController
  before_action :authenticate_user!

def intraday #get req
  if params[:symbol].present?
  api = AlphaVantageApi.new

  @intraday_data = api.time_series_intraday(params[:symbol])
  @stock_symbol = @intraday_data['Meta Data']['2. Symbol']
  @latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open')
  @stocks = Stock.where(symbol: params[:symbol], user_id: current_user.id)
  @stock_shares = @stocks.pluck(:shares).sum
  @stock_total_amount = @stocks.pluck(:cost_price).sum
end
end

def create #post .submit button
  api = AlphaVantageApi.new
  @symbol = params[:symbol]
  
    @intraday_data = api.time_series_intraday(@symbol)
    @latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open')
    @shares = params[:shares]
    @stock = Stock.new
    @stock.symbol = @symbol
    @stock.shares = @shares.to_i
    @stock.cost_price = @latest_open_value.to_i * @shares.to_i 
    @stock.user_id = current_user.id
    @stock.save

    @stocks = Stock.where(symbol: @symbol, user_id: current_user.id)
    redirect_to "/stocks/intraday?symbol=#{@symbol}&commit=Search+Stock"
  end
end


def index
  @stocks = Stock.all
end