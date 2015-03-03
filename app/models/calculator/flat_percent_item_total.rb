class Calculator::FlatPercentItemTotal < Calculator
  preference :flat_percent, :percent, :default => 0.0

  attr_accessible :preferred_flat_percent

  def self.description
    "Flat Percent"
  end

  def compute(cart)
    total = cart.total_ttc
    value = total * BigDecimal(self.preferred_flat_percent.to_s) / 100.0
    (value * 100).round.to_f / 100
  end
end
