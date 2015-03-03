FactoryGirl.define do
  factory :user do  |user|
    sequence(:email) {|n| "nicolas.vandenbogaerde_#{n}@gmail.com" } 
    sequence(:password) {|n| "infonies#{n}"}
    sign_in_count 1
    current_sign_in_at "2012-10-30 17:17:44.370258"
    last_sign_in_at "2012-10-30 14:43:37.988167"
    sequence(:current_sign_in_ip) { |n| "192.168.100.#{n}" }
    sequence(:last_sign_in_ip) { |n| "192.168.100.#{n}" }
    confirmed_at "2012-03-12 13:38:58.012221"
    confirmation_sent_at "2012-03-12 13:38:58.012221"
    plan_id 4
    sequence(:firstname) { |n| "firstname_#{n}" }
    sequence(:lastname) { |n| "lastname_#{n}" }
    sequence(:phone_number) { |n| "068114458#{n}" } 

    association :plan
    user.after(:build) do |u| 
      u.address = FactoryGirl.create(:address, :addressable => u) 
    end 
  end
end
