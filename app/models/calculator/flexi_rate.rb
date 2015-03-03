class Calculator::FlexiRate < Calculator
  preference :first_item,      :currency, :default => 0.0
  preference :additional_item, :currency, :default => 0.0
  preference :max_items,       :integer, :default => 0

  attr_accessible :preferred_first_item, :preferred_additional_item, :preferred_max_items

  def self.description
    "Flexible rate"
  end

  def self.available?(object)
    true
  end

  def compute(cart)
    sum = 0
    max = self.preferred_max_items.to_i
    items_count = (cart.items.sum {|item| item.quantity })
    items_count.times do |i|
      if (max == 0 && i == 0) || (max > 0) && (i % max == 0)
        sum += self.preferred_first_item.to_f
      else
        sum += self.preferred_additional_item.to_f
      end
    end
    sum    
  end

end
