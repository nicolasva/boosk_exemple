require 'spec_helper'

describe Taxon do
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:parent_id) }
  it { should allow_mass_assignment_of(:position) }
  it { should_not allow_mass_assignment_of(:taxonomy_id) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }

  it { should belong_to(:taxonomy) }
  it { should have_and_belong_to_many(:products) }  

  it { should validate_presence_of(:name) }

end