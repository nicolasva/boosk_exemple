require 'spec_helper'

describe Address do
  it { should allow_mass_assignment_of(:addr) }
  it { should allow_mass_assignment_of(:designation) }
  it { should allow_mass_assignment_of(:zip_code) }
  it { should allow_mass_assignment_of(:country) }
  it { should allow_mass_assignment_of(:state) }
  it { should allow_mass_assignment_of(:city) }

end
