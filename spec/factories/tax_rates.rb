FactoryGirl.define do
  factory :tax_rate do
    sequence(:label) {|n| "Label: {n}" }
    sequence(:rate) {|n| n }
    association :shop
    after(:build) { |s| s.class.skip_callback(:create, :after,:affect_shop_zone) }
  end
end
