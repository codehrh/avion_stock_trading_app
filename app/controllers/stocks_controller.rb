class StocksController < ApplicationController
  before_action :authenticate_user!

  def intraday
    if params[:symbol].present?
      api = AlphaVantageApi.new
      @intraday_data = api.time_series_intraday(params[:symbol])
  
      # Validate
      if @intraday_data && @intraday_data['Meta Data'] && @intraday_data['Time Series (5min)']
        @stock_symbol = @intraday_data['Meta Data']['2. Symbol']
        @latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open').to_f
  
        @stocks = Stock.where(symbol: params[:symbol], user_id: current_user.id)
        @stock_shares = @stocks.sum(:shares)
        @stock_total_amount = @stocks.sum(:cost_price)
      else
        flash[:alert] = "Could not retrieve intraday data for symbol '#{params[:symbol]}'. Please check the symbol or try again later."
      end
    else
      flash[:alert] = "Stock symbol is required."
    end
  end

  def create # buy
    api = AlphaVantageApi.new
    @symbol = params[:symbol]
    @shares = params[:shares].to_i
  
    @intraday_data = api.time_series_intraday(@symbol)
  
    if @intraday_data && @intraday_data['Time Series (5min)']
      @latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open').to_f
      purchase_price = @latest_open_value * @shares
  
      if current_user.balance >= purchase_price
        @stock = Stock.find_or_initialize_by(symbol: @symbol, user_id: current_user.id)
  
      # Update shares and cost price
        if @stock.persisted?
          @stock.shares += @shares
          @stock.cost_price += purchase_price
        else
          @stock.shares = @shares
          @stock.cost_price = purchase_price
        end
  
      @stock.save

      current_user.update(balance: current_user.balance - purchase_price)
  
      # Transaction record (buy)
      Transaction.create!(
        user_id: current_user.id,
        company_name: @symbol,
        shares: @shares,
        stock_price: @latest_open_value,
        total_price: purchase_price,
        action_type: "buy"
      )
      end
  
      redirect_to stocks_intraday_path(symbol: @symbol, commit: "Search Stock"), notice: "Successfully purchased #{@shares} shares of #{@symbol}."
    else

      redirect_to stocks_intraday_path, alert: "Unable to retrieve stock data for #{@symbol}. Please try again later."
    end
  end

  def update # sell
    if params[:symbol].present? && params[:subtract_shares].present?
      @symbol = params[:symbol]
      shares_to_subtract = params[:subtract_shares].to_i
  
      @stocks = Stock.where(symbol: @symbol, user_id: current_user.id)
      total_shares = @stocks.sum(:shares) 
  
      if total_shares >= shares_to_subtract
        api = AlphaVantageApi.new
        @intraday_data = api.time_series_intraday(@symbol)
        if @intraday_data && @intraday_data['Time Series (5min)']
          latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open').to_f
          selling_price = latest_open_value * shares_to_subtract
  
          # Balance update (for sell)
          current_user.update(balance: current_user.balance + selling_price)
  
          # Adjust stock holdings
          remaining_shares = total_shares - shares_to_subtract
          @stocks.destroy_all # Sold shares deletion
  
          if remaining_shares > 0
            Stock.create(
              symbol: @symbol,
              user_id: current_user.id,
              shares: remaining_shares,
              cost_price: latest_open_value * remaining_shares 
            )
          end
  
          # Transaction Recording (Sell)
          Transaction.create(
            company_name: @symbol, 
            total_price: selling_price,
            stock_price: latest_open_value,
            user_id: current_user.id,
            action_type: "sell",
            shares: shares_to_subtract
          )
  
          flash[:notice] = "#{shares_to_subtract} shares successfully sold. $#{selling_price} added to your balance. New balance: $#{current_user.balance}."
        else
          flash[:alert] = "Failed to retrieve stock data. Please try again."
        end
      else
        flash[:alert] = "Not enough shares to sell."
      end
    else
      flash[:alert] = "Invalid request."
    end
  
    redirect_to stocks_intraday_path(symbol: @symbol, commit: "Search Stock")
  end
end