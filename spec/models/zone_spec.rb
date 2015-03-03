require 'spec_helper'

describe Zone do
  before(:all) do
    @zone = create(:zone)
  end

  subject { create(:zone) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:zone_members) }
  it { should allow_mass_assignment_of(:zone_members_codes) }
  it { should_not allow_mass_assignment_of(:shop_id) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:shop_id) }
  it { should validate_uniqueness_of(:name).scoped_to(:shop_id)}

  it { should belong_to(:shop) }
  it { should have_many(:zone_members).dependent(:destroy) }
  it { should have_many(:shipping_methods).dependent(:destroy) }

end
