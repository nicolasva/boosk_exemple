class Calculator::FlatRate < Calculator
  preference :amount, :currency, :default => 0.0
  attr_accessible :preferred_amount

  def self.description
    "Flat rate (per order)"
  end

  def compute(object=nil)
    self.preferred_amount
  end

end
