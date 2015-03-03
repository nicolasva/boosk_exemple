class Calculator::PerItem < Calculator
  preference :amount, :currency, :default => 0.0

  attr_accessible :preferred_amount

  def self.description
    "Flat rate (per item)"
  end

  def compute(cart)
    (self.preferred_amount * (cart.items.sum {|item| item.quantity }))
  end

end
