class StocksController < ApplicationController

  before_action :authenticate_user!

  def intraday
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
  
  def create
    api = AlphaVantageApi.new
    @symbol = params[:symbol]
    @shares = params[:shares].to_i
  
    @intraday_data = api.time_series_intraday(@symbol)
    @latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open').to_i
  
    @stock = Stock.find_or_initialize_by(symbol: @symbol, user_id: current_user.id)

    #if @stock already exists in the database; shares are incremented by @shares.
    if @stock.persisted?
      @stock.shares += @shares
    else
      @stock.shares = @shares
    end
  
    # cost_price updating
    # @stock.cost_price = @latest_open_value * @shares
    new_price = @latest_open_value * @shares
    if @stock.cost_price
      @stock.cost_price += new_price
    else
      @stock.cost_price = new_price
    end

    if @stock.save

    Transaction.create(
      stock_price: @latest_open_value,
      total_price: new_price, #stockprice+shares
      shares: @shares,
      symbol: @symbol,
      user: current_user,
    )
    end
  
    redirect_to "/stocks/intraday?symbol=#{@symbol}&commit=Search+Stock"
  end
end