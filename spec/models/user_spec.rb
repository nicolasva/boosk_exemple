require 'spec_helper'

describe User do
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:remember_me) }
  it { should allow_mass_assignment_of(:facebook_uid) }
  it { should allow_mass_assignment_of(:facebook_token) }
  it { should allow_mass_assignment_of(:plan_id) }
  it { should allow_mass_assignment_of(:created_at) }

  it { should_not allow_mass_assignment_of(:updated_at) }

  it { should have_and_belong_to_many(:shops) }

  it { should validate_format_of(:email).with("example@example.com") }
  it { should validate_format_of(:email).not_with("example") }

end
