require 'spec_helper'

describe PromotionRule do
  it { should belong_to(:promotion) }
end