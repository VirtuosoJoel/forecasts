require 'open-uri' # Get data from API
require 'json'     # Interpret data from API
require 'uri'      # Escape location String

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation
  attr_accessible :current_location, :current_days, :prev_location, :prev_days
  
  API_Key = 'qmv3hm4qz9m7pbvgkgngg8ed'.freeze

  def get_forecast!( params_hash={} )
  
    params_hash[:location] ||= current_location
    params_hash[:days] ||= current_days
  
    if params_hash[:location] != prev_location || params_hash[:days] != prev_days 
      
      update_attributes( prev_location: current_location, prev_days: current_days, current_location: params_hash[:location], current_days: params_hash[:days] )
      
    end
    
    self.class.get_forecast( params_hash )
  
  end
  
  def previous_forecast
    get_forecast!( { location: prev_location, days: prev_days } )
  end
  
  def self.get_forecast( params_hash={} )
  
    params_hash[:location] ||= 'London'
    params_hash[:days] ||= 1
  
    search_string = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=#{ URI.escape( params_hash[:location] ) }&format=json&num_of_days=#{ params_hash[:days] }&key=#{ API_Key }"
    ActiveSupport::JSON.decode( open( search_string ).read )
    
  end
  
end