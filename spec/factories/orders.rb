# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do |order|
    sequence(:number) {|n| "C00#{n}" }
    credit_total 1
    payment_total 4
    sequence(:item_total) { |n| n }
    sequence(:total) { |n| n }
    payment_state "Fr"
    sequence(:email) {|n| "email#{n}@example.com" }
    sequence(:special_instructions) {|n| "special instructions #{n}"}
    workflow_state 'unpaid'

    association :shop 

    after(:create) do |o| 
      o.contact = FactoryGirl.create(:contact, :contactable => o) 
    end 
  end
end
