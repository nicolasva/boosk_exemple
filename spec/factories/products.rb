FactoryGirl.define do
  factory :product do
    sequence(:uuid) {|n| "3b9ca953-8502-3505-658c-8c0d123fbc1#{n}" }
    sequence(:name) {|n| "Product name #{n}" }
    sequence(:description) {|n| "Description content #{n}" }
    sequence(:permalink) {|n| "http://shop.boosket.com/product/#{n}" }
    sequence(:highlight) {|n| false }
    association :shop
    association :tax_rate
    after(:build) { |p| p.product_variants << create(:product_variant, :product_id => p.id) }
  end
end
