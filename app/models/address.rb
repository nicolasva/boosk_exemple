class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  attr_accessor :object_type

  validates :city, :zip_code, :addr, :presence => true, :unless => Proc.new {|a| a.object_type == "shop" }

  validates :country, :presence => true

end
