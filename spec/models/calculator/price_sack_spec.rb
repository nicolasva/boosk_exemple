require 'spec_helper'

describe Calculator::PriceSack do
  let(:calculator) { Calculator::PriceSack.new :preferred_normal_amount => 10, :preferred_discount_amount => 5 }
  let(:order) { mock_model Order, :amount => 30 }

  context "when order amount is lower than minimal amount" do
    before { calculator.preferred_minimal_amount = 60 }
    it "should apply normal rate" do
      calculator.compute(order).should == 10
    end
  end

  context "when order amount is equal to minimal amount" do
    before { calculator.preferred_minimal_amount = 30 }
    it "should apply discount rate" do
      calculator.compute(order).should == 5
    end
  end

  context "when order amount is greater than minimal amount " do
    before { calculator.preferred_minimal_amount = 10 }
    it "should apply discount rate" do
      calculator.compute(order).should == 5
    end
  end
end