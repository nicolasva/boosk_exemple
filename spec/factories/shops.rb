FactoryGirl.define do
  factory :shop do
    sequence(:uuid) {|n| "3c256d22-5628-4e56-bdb0-886170203c2#{n}" }
    sequence(:slug) {|n| "test-#{n}" }
    sequence(:name) {|n| "test#{n}" }
    sequence(:baseline) {|n| "baseline_#{n}" }
    sequence(:description) {|n| "description_#{n}" } 
    sequence(:terms) {|n| "terms_#{n}"}
    sequence(:url_website) {|n| "http://google.c#{n}" }
    sequence(:devise) {|n| "devise_#{n}" }
    has_active_payement true 
    sequence(:fan_page_id) {|n| n }
    sequence(:google_shopping_key){|n| n }
    sequence(:paypal_account){|n| "paypal_account_#{n}"}
    facebook_status true
    mobile_status true
    google_shopping_status true
    web_status true
    tv_status true

    after(:build) { |s| s.class.skip_callback(:create, :after,:create_shop_zone) }
    after(:build) { |s| s.class.skip_callback(:create, :after,:send_notif_for_invit) }

    after(:create) do |s| 
      s.contact = FactoryGirl.create(:contact, :contactable => s) 
    end 
  end
end
