FactoryGirl.define do
  factory :line_item do
    sequence(:price) { |price| price }
    sequence(:quantity) { |quantity| quantity }
    association :product_variant
  end
end
