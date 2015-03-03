FactoryGirl.define do
  factory :product_variant_picture do
    picture "picture_name.png"
    association :product_variant 
  end
end
