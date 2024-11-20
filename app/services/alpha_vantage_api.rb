
require 'uri'
require 'net/http'
require 'json'

class AlphaVantageApi
    BASE_URL = "https://alpha-vantage.p.rapidapi.com/query".freeze

    def initialize
        @api_key = ENV["RAPIDAPI_KEY"]
    end

    def time_series_intraday(symbol)
        url = URI("#{BASE_URL}?datatype=json&output_size=compact&interval=5min&function=TIME_SERIES_INTRADAY&symbol=#{symbol}")
        make_request(url)
    end
    
    private

    def make_request(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-key"] = @api_key
        request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com'

        response = http.request(request)
        JSON.parse(response.body)
    end
end