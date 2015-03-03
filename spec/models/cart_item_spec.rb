require 'spec_helper'

describe CartItem do
  before(:all) do
    @product = create(:product_variant, :product => create(:product, :tax_rate_id => create(:tax_rate)))
  end

  before(:each) do
    @cart_item = CartItem.new(@product)
  end

  subject { @cart_item }
  it { should respond_to(:product) }
  it { should respond_to(:quantity) }

  it "should set an initial quantity of 1" do
    @cart_item.quantity.should == 1
  end

  it "should initialize product" do
    @cart_item.product.should == @product
  end

  describe "#increment_quantity" do
    it { expect {@cart_item.increment_quantity}.to change{@cart_item.quantity}.by(1) }
  end
  
  describe "#title" do
    subject { @cart_item.title }
    it { should == @product.product.name }
  end

  describe "#price" do
    subject { @cart_item.price }
    it { should == @product.price * @cart_item.quantity }
  end
end
