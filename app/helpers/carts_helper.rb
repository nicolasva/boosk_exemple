module CartsHelper
  def total_product(cart_items)
    tmp = 0.0
    cart_items.each do |cart_item|
      tmp += cart_item.product.price_ttc.to_f * cart_item.quantity.to_f
    end
    return tmp.to_s
  end
end
