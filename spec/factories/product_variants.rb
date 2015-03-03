FactoryGirl.define do
  factory :product_variant do
    sequence(:sku) {|n| "Sku #{n}" }
    sequence(:price) {|n| n }
    sequence(:weight) {|n| n }
    sequence(:quantity) {|n| n }
    height 500
    depth 30
    width 200
  end
end
