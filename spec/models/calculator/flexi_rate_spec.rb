require 'spec_helper'

describe Calculator::FlexiRate do
  let(:calculator) { Calculator::FlexiRate.new }
  before(:each) do
    @v1 = create(:product_variant, :quantity => 1, :price => 10,:product_id => create(:product))
    @v2 = create(:product_variant, :quantity => 9, :price => 23,:product_id => create(:product))

    @cart = Cart.new
    @cart.items = [@v1, @v2]
  end
  context "compute" do
    it "should compute amount correctly when all fees are 0" do
      calculator.compute(@cart).round(2).should == 0.0
    end

    it "should compute amount correctly when first_item has a value" do
      calculator.stub :preferred_first_item => 1.0
      calculator.compute(@cart).round(2).should == 1.0
    end

    it "should compute amount correctly when additional_items has a value" do
      calculator.stub :preferred_additional_item => 1.0
      calculator.compute(@cart).round(2).should == 9.0
    end

    it "should compute amount correctly when additional_items and first_item have values" do
      calculator.stub :preferred_first_item => 5.0, :preferred_additional_item => 1.0
      calculator.compute(@cart).round(2).should == 14.0
    end

    it "should compute amount correctly when additional_items and first_item have values AND max items has value" do
      calculator.stub :preferred_first_item => 5.0, :preferred_additional_item => 1.0, :preferred_max_items => 3
      calculator.compute(@cart).round(2).should == 26.0
    end

    it "should allow creation of new object with all the attributes" do
      Calculator::FlexiRate.new(:preferred_first_item => 1, :preferred_additional_item => 1, :preferred_max_items => 1)
    end
  end
end
