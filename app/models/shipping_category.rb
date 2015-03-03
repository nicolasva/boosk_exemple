class ShippingCategory < ActiveRecord::Base
  belongs_to :shop
  has_many :products, :dependent => :nullify
  has_many :shipping_methods, :dependent => :nullify
  has_many :products

  attr_accessible :name

  validates :name, :presence => true
  validates :shop_id, :presence => true
end
