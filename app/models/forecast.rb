class Forecast

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :location, :days

  validates :location, length: { minimum: 3 }

  validates :days, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5 }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
 end
