# Class to control input form, not logged in database
class Forecast

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :location, :days

  # Try and catch some invalid locations
  validates :location, length: { minimum: 3 }

  # Match API restriction on days
  validates :days, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5 }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
 end