require 'spec_helper'

describe ZoneMember do
  before(:all) do
    @zone_member = FactoryGirl.create :zone_member
  end

  it { should allow_mass_assignment_of(:zone) }
  it { should allow_mass_assignment_of(:zone_id) }
  it { should allow_mass_assignment_of(:code) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }

  it { should belong_to(:zone) }

end
