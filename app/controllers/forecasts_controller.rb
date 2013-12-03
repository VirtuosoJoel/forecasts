class ForecastsController < ApplicationController

  API_Key = 'qmv3hm4qz9m7pbvgkgngg8ed'.freeze

  require 'open-uri' # Get data from API
  require 'json' # Interpret data from API
  
  def index
   respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def search
    data = ActiveSupport::JSON.decode(open("http://api.worldweatheronline.com/free/v1/weather.ashx?q=london&format=json&num_of_days=5&key=#{ API_Key }").read)
    respond_to do |format|
      format.html # search.html.erb
    end
  end

end
