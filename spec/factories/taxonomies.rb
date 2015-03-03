FactoryGirl.define do
  factory :taxonomy do
    sequence(:name) {|n| "Fake taxonomy #{n}" }
    association :shop
  end
end
