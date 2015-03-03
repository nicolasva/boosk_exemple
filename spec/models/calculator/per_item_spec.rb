require 'spec_helper'

describe Calculator::PerItem do
  let!(:calculator) do
    calculator = Calculator::PerItem.new(:preferred_amount => 10)
  end

  before(:each) do
    @product = create(:product_variant, :quantity => 1)
    @product2 = create(:product_variant, :quantity => 6)

    @cart = Cart.new
    @cart.items = [@product,@product2]
  end

  describe "#compute" do
    it "should correctly calculate per item shipping" do
      calculator.compute(@cart).to_f.should == 70 #  7 x 10
    end
  end
end
