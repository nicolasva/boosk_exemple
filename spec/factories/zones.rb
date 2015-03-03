FactoryGirl.define do
  factory :zone do
    sequence(:name) {|n| "Shop test #{n}" }
    association :shop
  end
end
