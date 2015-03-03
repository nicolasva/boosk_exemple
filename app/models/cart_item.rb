class CartItem
  attr_accessor :product, :quantity, :id, :picture, :price_ttc, :tax

  def initialize(product, quantity = 1)
    @name = product.product.name
    @quantity = quantity.to_i
    @id = product.id
    @picture = product.pictures.get_master.first
    @tax = product.product.tax_rate.rate.to_f unless product.product.tax_rate.nil?
    @price_ttc = (product.price * (1 + (!@tax.nil? ? @tax : 0) / 100) * 1).round(2)
    @product = product
  end

  def increment_quantity
    @quantity = self.control_quantity(@quantity+ 1)
  end

  def set_quantity(quantity)
    @quantity = self.control_quantity(quantity)
  end
  
  def title
    @product.product.name
  end

  def price
    @product.price * @quantity
  end

  def control_quantity(quantity)
    quantity = 1 if quantity.to_i < 1
    quantity = self.product.quantity.to_i < quantity.to_i ? self.product.quantity.to_i : quantity.to_i
    quantity
  end
end
