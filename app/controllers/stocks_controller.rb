class StocksController < ApplicationController
      def intraday
    if params[:symbol].present?
      api = AlphaVantageApi.new
      @intraday_data = api.time_series_intraday(params[:symbol])
      @stock_symbol = @intraday_data['Meta Data']['2. Symbol']
      @latest_open_value = @intraday_data['Time Series (5min)'].values.first.dig('1. open')
    end
  end
  def create
    @quantity = params[:quantity].to_i
    @latest_open_value = ... # fetch the latest open value
    action = params[:action]
    if action == "add"
        @quantity += 1
    elsif action == "subtract" && @quantity > 0
        @quantity -= 1
    end
    @total = @latest_open_value * @quantity
  end
end
