require 'spec_helper'

describe Customization do
  it { should_not allow_mass_assignment_of(:shop_id) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }
  it { should allow_mass_assignment_of(:background_color_shop) }
  it { should allow_mass_assignment_of(:background_color_product_list) }
  it { should allow_mass_assignment_of(:background_color_product_thumb) }
  it { should allow_mass_assignment_of(:background_color_sidebar) }
  it { should allow_mass_assignment_of(:background_color_sidebar_item) }
  it { should allow_mass_assignment_of(:baseline_color) }
  it { should allow_mass_assignment_of(:border_color) }
  it { should allow_mass_assignment_of(:color_text) }
  it { should allow_mass_assignment_of(:color_link) }
  it { should allow_mass_assignment_of(:color_text_product) }
  it { should allow_mass_assignment_of(:products_per_page) }
  it { should allow_mass_assignment_of(:fan_access) }
  it { should allow_mass_assignment_of(:search_engine) }  
  it { should allow_mass_assignment_of(:logo) }
  it { should allow_mass_assignment_of(:header_attributes) }
  it { should allow_mass_assignment_of(:footer_attributes) }
  it { should allow_mass_assignment_of(:teaser) }
  it { should allow_mass_assignment_of(:shutter) }
  it { should allow_mass_assignment_of(:color_text_menu) }
  it { should allow_mass_assignment_of(:color_text_menu_hover) }

  it { should belong_to(:shop) }
  it { should have_one(:header) }
  it { should have_one(:footer) }
  it { should validate_presence_of(:shop) }
  it { should validate_numericality_of(:products_per_page) }
  it { should_not allow_value(2).for(:products_per_page) }
  it { should allow_value(3).for(:products_per_page) }
  it { should_not allow_value(3.14).for(:products_per_page) }

end