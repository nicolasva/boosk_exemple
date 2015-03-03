# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact_email do
    sequence(:email) {|n| 'contact@boosket.com' }
    association :contact
  end
end
