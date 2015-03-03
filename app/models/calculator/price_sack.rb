class Calculator::PriceSack < Calculator
  preference :minimal_amount, :currency, :default => 0.0
  preference :normal_amount, :currency, :default => 0.0
  preference :discount_amount, :currency, :default => 0.0

  attr_accessible :preferred_minimal_amount,
                  :preferred_normal_amount,
                  :preferred_discount_amount

  def self.description
    "Price sack"
  end

  def compute(object)
    if object.is_a?(Array)
      base = object.map { |o| o.respond_to?(:amount) ? o.amount : o.to_d }.sum
    else
      base = object.respond_to?(:amount) ? object.amount : object.to_d
    end

    if base >= self.preferred_minimal_amount
      self.preferred_discount_amount
    else
      self.preferred_normal_amount
    end
  end
end