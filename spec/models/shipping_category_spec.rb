require 'spec_helper'

describe ShippingCategory do
  it { should allow_mass_assignment_of(:name) }
  it { should_not allow_mass_assignment_of(:shop_id) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }

  it { should belong_to(:shop) }
  it { should have_many(:shipping_methods).dependent(:nullify) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:shop_id) }
end
