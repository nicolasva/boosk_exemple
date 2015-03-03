FactoryGirl.define do
  factory :customization do
    background_color_shop "#FFFFFF"
    background_color_product_list "#ECECEC"
    background_color_product_thumb "#FFFFFF"
    background_color_sidebar "#D8DFEA"
    baseline_color "#1D4088"
    border_color "#DADADA"
    color_text "#000000"
    color_link "#3B5998"
    color_text_product "#000000"
    color_text_menu "#FFFFFF"
    color_text_menu_hover "#F77D00"
    color_link_product "#3B5998"
    products_per_page "9"
    fan_access false
    search_engine false
    association :shop  
  end
end
