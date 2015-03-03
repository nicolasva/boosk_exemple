FactoryGirl.define do
  factory :option_type do
    sequence(:name) {|n| "name test #{n}"}
    sequence(:value) {|n| "value_#{n}"}
    association :shop
  end 
end
