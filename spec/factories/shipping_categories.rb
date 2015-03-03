FactoryGirl.define do
  factory :shipping_category do
    sequence(:name) {|n| "Shipping category #{n}" }
    association :shop
  end
end
