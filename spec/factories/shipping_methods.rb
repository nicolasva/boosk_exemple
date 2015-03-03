FactoryGirl.define do
  factory :shipping_method do
    sequence(:name) {|n| "Shipping method #{n}" }
    association :shop
    association :zone
    calculator_type "Calculator::PerItem"
  end

  factory :shipping_method_with_category, class: ShippingMethod do
    sequence(:name) {|n| "Shipping method #{n}" }
    association :shop
    association :zone
    association :calculator
    association :shipping_category
  end
end
