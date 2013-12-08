require 'open-uri' # Get data from API
require 'json'     # Interpret data from API
require 'uri'      # Escape location String

# User class, logged in database
class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # User attributes
  attr_accessible :email, :password, :password_confirmation
  
  # User forecast history (terms only)
  attr_accessible :current_location, :current_days, :prev_location, :prev_days
  
  API_Key = 'qmv3hm4qz9m7pbvgkgngg8ed'.freeze

  # Log user changes + return forecast data
  def get_forecast!( params_hash={} )
  
    # Use last known search if no params given.
    params_hash[:location] ||= current_location
    params_hash[:days] ||= current_days
  
    # If it's a new forecast
    if params_hash[:location] != prev_location || params_hash[:days] != prev_days 
      
      # Log the changes
      update_attributes( prev_location: current_location, prev_days: current_days, current_location: params_hash[:location], current_days: params_hash[:days] )
      
    end
    
    # Return forecast data
    self.class.get_forecast( params_hash )
  
  end

  # In case we add a 'previous' link for registered users.
  def previous_forecast
    self.class.get_forecast( { location: prev_location, days: prev_days } )
  end
  
  # Return forecast data
  # Note: This is a class method so it can also be used with unregistered users
  def self.get_forecast( params_hash={} )
  
    # Default to London, 1 day unless params given
    params_hash[:location] ||= 'London'
    params_hash[:days] ||= 1
  
    # Get forecast data in JSON, and convert to nested Hash/Array format
    search_string = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=#{ URI.escape( params_hash[:location] ) }&format=json&num_of_days=#{ params_hash[:days] }&key=#{ API_Key }"
    ActiveSupport::JSON.decode( open( search_string ).read )
    
  end
  
end