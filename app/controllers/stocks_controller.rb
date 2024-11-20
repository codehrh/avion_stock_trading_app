class StocksController < ApplicationController

  before_action :authenticate_user!

  def intraday #get req
    if params[:symbol].present?
    api = AlphaVantageApi.new
  
    @intraday_data = api.time_series_intraday(params[:symbol])
    @stock_symbol = @intraday_data['Meta Data']['2. Symbol']
    @latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open') #Stock price
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
  
    # initialize a stock for the current user n symbol
    @stock = Stock.find_or_initialize_by(symbol: @symbol, user_id: current_user.id)
  
    # set the attributes
    if @stock.persisted?
      @stock.shares += @shares
    else
      @stock.shares = @shares
    end
  
    # @stock.cost_price = @latest_open_value * @shares
    new_price = @latest_open_value * @shares
    if @stock.cost_price
      @stock.cost_price += new_price
    else
      @stock.cost_price = new_price
    end
    @stock.save
  
    redirect_to "/stocks/intraday?symbol=#{@symbol}&commit=Search+Stock"
  end
  
  



  def update
    if params[:symbol].present? && params[:subtract_shares].present? 
      @symbol = params[:symbol]
      shares_to_subtract = params[:subtract_shares].to_i
  
      @stocks = Stock.where(symbol: @symbol, user_id: current_user.id)
      total_shares = @stocks.sum(:shares) # total shares owned by the user for stock (symbol)sum nung shares 
   
      if total_shares >= shares_to_subtract
        remaining_shares = total_shares - shares_to_subtract
        @stocks.destroy_all
  
        if remaining_shares > 0
          Stock.create(
            symbol: @symbol, 
            user_id: current_user.id, 
            shares: remaining_shares
          )
        end
  
        flash[:notice] = "#{shares_to_subtract} shares successfully subtracted"
      else
        flash[:alert] = "Not enough shares to subtract"
      end
    end
  
    redirect_to "/stocks/intraday?symbol=#{@symbol}&commit=Search+Stock"
  end
end