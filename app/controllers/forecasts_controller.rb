class ForecastsController < ApplicationController

  def index
  
    user = current_user
  
    @data = if user && user.current_location && user.current_days
      user.get_forecast!
    else
      User.get_forecast
    end

    @forecast ||= Forecast.new
    
    respond_to do |format|
      format.html
    end
    
  end

  def create
   
    @forecast = Forecast.new params[:forecast]

    respond_to do |format|
    
      if @forecast.valid?
      
        @data = if user_signed_in?
          current_user.get_forecast! params[:forecast]
        else
          User.get_forecast params[:forecast]          
        end
        
      else
        
        @data = nil
        
      end

      format.html { render :index }
    end
    
  end

end