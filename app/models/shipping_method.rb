class ShippingMethod < ActiveRecord::Base
  belongs_to :zone
  belongs_to :shipping_category
  belongs_to :shop, touch: true
  belongs_to :product
  has_one :calculator, :dependent => :destroy
  accepts_nested_attributes_for :calculator

  validates :name, :zone, :calculator, :presence => true

  attr_accessible :name, :zone_id, :shipping_category_id, :match_none, :match_one, :match_all
  attr_accessible :calculator_type, :calculator_attributes

  def self.calculators
    return [
      Calculator::FlatPercentItemTotal,
      Calculator::FlatRate,
      Calculator::FlexiRate,
      Calculator::PerItem]
  end

  def self.match_by_buyer(country, state, shop_id)
    shop = Shop.find_by_uuid(shop_id)

    unless state.nil?
      shipping = shop.shipping_methods.includes(:zone => [:zone_members]).where(['zone_members.code = ?',state]).first
      if shipping.nil?
        shipping = shop.shipping_methods.includes(:zone => [:zone_members]).where(['zone_members.code = ?',country]).first
      end
    else
      shipping = shop.shipping_methods.includes(:zone => [:zone_members]).where(['zone_members.code = ?',country]).first
    end
    
    return shipping
  end

  def calculator_type
    calculator.class.to_s if calculator
  end

  def calculator_type=(calculator_type)
    clazz = calculator_type.constantize if calculator_type
    self.calculator = clazz.new if clazz and not self.calculator.is_a? clazz
  end

  def calculator_attributes
    calculator.preferences if calculator
  end

  def category_match?(order)
    return true if shipping_category.nil?
    if match_all
      order.products.all? { |p| p.shipping_category == shipping_category }
    elsif match_one
      order.products.any? { |p| p.shipping_category == shipping_category }
    elsif match_none
      order.products.all? { |p| p.shipping_category != shipping_category }
    end
  end

  def available_to_order?(order)
    return false if order.nil?
    zone_check = zone && zone.include?(order.contact)
    category_check = category_match?(order)
    zone_check && category_check
  end

  def self.all_available(order)
    joins(:zones => :shop).where(:shop => {:id => order.shop_id}).select { |method| method.available_to_order?(order) }
  end

  def as_json(options={})
    super(options.merge(include: [:zone, :shipping_category], methods: [:calculator_type, :calculator_attributes]))
  end
end
