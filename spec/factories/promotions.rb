FactoryGirl.define do
  factory :promotion do
    sequence(:name) {|n| "Test promotion #{n}" }
    association :shop
    starts_at { Time.now }
    free_shipping false
    percent_discount false
    discount_amount 5 
  end
end