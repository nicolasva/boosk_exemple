class Cart
  attr_accessor :items,:shipping, :total, :total_with_shipping

  def initialize
    @items = []
    @shipping = 0
    @total = 0
    @total_with_shipping = 0
    @is_deliverable = false
  end

  def add_product(product, quantity = 1)
    current_item = CartItem.new(product, quantity)
    @items << current_item
    @total = total_ttc
    current_item
  end

  def edit_product(product, quantity)
    current_item = @items.find {|item| 
      item.product.id == product.id
    }
    current_item.set_quantity(quantity) if current_item
    @total = total_ttc
    return current_item
  end

  def compute_shipping(shipping_method)
    unless shipping_method.nil?
      @shipping = shipping_method.calculator.compute(self).round(2)
      @total_with_shipping = (@total + @shipping).round(2)
      @is_deliverable = true
    else
      @is_deliverable = false
    end
  end

  def remove_product(product)
    current_item = @items.find {|item| item.product == product}
    @items.delete(current_item) unless current_item.nil?
    @total = total_ttc
    current_item
  end

  def total_ht
    t = items.sum {|item| item.product.price.to_f * item.quantity.to_i}
    t.round(2)
  end

  def total_ttc
    t = @items.sum {|item| item.price_ttc.to_f * item.quantity.to_i}
    t.round(2)
  end

  def total_items
    @items.sum {|item| item.quantity.to_i}
  end
end
