class ForecastsController < ApplicationController

  # Default page
  def index
  
    # Avoid multiple method calls by assigning user to local variable
    user = current_user
  
    # If there's a user with valid data
    @data = if user && user.current_location && user.current_days
      # Get a forecast with the user's preferences
      user.get_forecast!
    # If there isn't a user with valid data
    else
      # Default to London, 1 day
      User.get_forecast
    end

    # Initialize class for form
    @forecast ||= Forecast.new
    
    # Render index
    respond_to do |format|
      format.html
    end
    
  end

  # Form action
  def create
   
    # Initialize form with given data
    @forecast = Forecast.new params[:forecast]

    # Render index with...
    respond_to do |format|
    
      # If the form was filled in correctly
      if @forecast.valid?
      
        # If we're dealing with a registered user
        @data = if user_signed_in?
          # Update database and get forecast data
          current_user.get_forecast! params[:forecast]
        # If it's an anonymous user
        else
          # Get forecast data, no database logging
          User.get_forecast params[:forecast]          
        end
        
      # If the form isn't filled in correctly
      else
        
        # Notify the view there's no forecast data
        # Note: the Forecast class will handle error messages
        @data = nil
        
      end

      format.html { render :index }
    end
    
  end

end