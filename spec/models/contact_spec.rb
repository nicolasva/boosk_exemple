require 'spec_helper'

describe Contact do
  it { should have_many(:emails).dependent(:destroy) }
  it { should belong_to(:contactable) }

  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
end
