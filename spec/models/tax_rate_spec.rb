require 'spec_helper'

describe TaxRate do
  it { should allow_mass_assignment_of(:label) }
  it { should allow_mass_assignment_of(:rate) }

  it { should belong_to(:shop) }
  it { should have_and_belong_to_many(:zones) }

  it { should validate_presence_of(:label) }
  it { should validate_presence_of(:rate) }
end
