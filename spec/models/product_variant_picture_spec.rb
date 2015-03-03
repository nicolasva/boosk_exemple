require 'spec_helper'

describe ProductVariantPicture do
  it { should allow_mass_assignment_of(:picture) }
  it { should allow_mass_assignment_of(:cached_path) }
  it { should allow_mass_assignment_of(:is_master) }
  it { should_not allow_mass_assignment_of(:product_variant_id) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }
end
