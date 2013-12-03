require 'open-uri' # Get data from API
require 'json' # Interpret data from API

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  attr_accessible :current_location, :current_days, :prev_location, :prev_days
  
  API_Key = 'qmv3hm4qz9m7pbvgkgngg8ed'.freeze

  def get_forecast!( location=current_location, days=current_days )
  
    if location != prev_location || days != current_days 
      
      self.prev_location, self.prev_days = self.current_location, self.current_days
      self.current_location, self.current_days = location, days
      
      save!
      
    end
    
    self.class.get_forecast( location, days )
  
  end
  
  def self.get_forecast( location, days )
  
    search_string = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=#{ location }&format=json&num_of_days=#{ days }&key=#{ API_Key }"
    ActiveSupport::JSON.decode( open( search_string ).read )
    
  end
  
end