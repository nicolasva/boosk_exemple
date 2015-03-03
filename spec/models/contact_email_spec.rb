require 'spec_helper'

describe ContactEmail do
  it { should belong_to(:contact) }

  it { should validate_presence_of(:email) }
end
