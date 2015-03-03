FactoryGirl.define do
  factory :contact do
    sequence(:firstname) {|n| "Firstname #{n}" }
    sequence(:lastname) {|n| "Lastname #{n}" }
    sequence(:phone) {|n| "#{n}" }


    after(:create) do |c|
      c.addresses << FactoryGirl.create(:address, :addressable => c)
    end
  end
end
