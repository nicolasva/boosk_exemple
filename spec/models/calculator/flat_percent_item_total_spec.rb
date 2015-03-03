require 'spec_helper'

describe Calculator::FlatPercentItemTotal do
  let!(:calculator) do
    calculator = Calculator::FlatPercentItemTotal.new(:preferred_amount => 10)
  end

  before(:each) do
    @v1 = create(:product_variant, :quantity => 1, :price => 10,:product => create(:product, :tax_rate_id => create(:tax_rate)))
    @v2 = create(:product_variant, :quantity => 9, :price => 10,:product => create(:product, :tax_rate_id => create(:tax_rate)))

    @cart = Cart.new
    @cart.items = [@v1, @v2]
  end

  before { calculator.stub :preferred_flat_percent => 10 }

  describe "#compute" do
    it "should compute amount correctly" do
      @cart = Cart.new
      @cart.items = [@v1, @v2]
      calculator.compute(@cart).to_f.should == 10.1
    end

    it "should round result correctly" do
      @cart.items[0].price = 10.90
      @cart.items[1].price = 11.07
      calculator.compute(@cart).to_f.should == 11.16

      @cart.items[1].price = 11.08
      calculator.compute(@cart).to_f.should == 11.17
    end
  end
end
