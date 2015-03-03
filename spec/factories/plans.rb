FactoryGirl.define do
  factory :plan do  |user|
    name "premium"
    monthly_price 29
    yearly_price 228
    number_admin  3
    number_f_shop  1
    number_m_shop  1
    number_w_shop  0
    number_product  5000
    has_google_shopping  true
    has_social  true
    has_feature_product  true
    has_data_import  true
    has_deals  true
    has_auto_data_import  24
    has_customization  true
    has_analytics  true
    has_api_access  false

    trait :start do
      name "start"
      monthly_price 1
      yearly_price 10
      number_admin  1
      number_f_shop  1
      number_m_shop  1
      number_w_shop  0
      number_product  50
      has_google_shopping  false
      has_social  true
      has_feature_product  true
      has_data_import  false
      has_deals  true
      has_auto_data_import  0
      has_customization  false
      has_analytics  false
      has_api_access  false
    end

    trait :premium do
      name "premium"
      monthly_price 29
      yearly_price 228
      number_admin  3
      number_f_shop  1
      number_m_shop  1
      number_w_shop  0
      number_product  5000
      has_google_shopping  true
      has_social  true
      has_feature_product  true
      has_data_import  true
      has_deals  true
      has_auto_data_import  24
      has_customization  true
      has_analytics  true
      has_api_access  false
    end
  end
end
