class ForecastsController < ApplicationController

  def index
  
    @forecast = Forecast.new
  
    user = current_user
  
    @data = if user && user.current_location && user.current_days
      user.get_forecast!
    else
      User.get_forecast( 'London', 7 )
    end

    respond_to do |format|
      format.html
    end
    
  end

  def create
    redirect_to action: "search"
  end
  
  def search
    
    args = params[:location], params[:days]
    
    @data = if user_signed_in?
    
      current_user.get_forecast! *args
      
    else

      User.get_forecast *args
      
    end

    respond_to do |format|
      format.html { render :index }
    end
    
  end

end
