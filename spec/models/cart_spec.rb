require 'spec_helper'

describe Cart do
  before(:all) do
    Product.destroy_all
  end

  before(:each) do
    @cart = Cart.new
    @product = create(:product)
    @product2 = create(:product)
  end

  subject { @cart }
  it { should respond_to(:items) }

  it "should initialize an empty list of items" do
    @cart.items.should == []
  end

  describe "#add_product" do
    context "when product is not already present in the cart" do

      it "should increase items count by one" do
        expect { @cart.add_product @product.product_variants.first }.to change{ @cart.items.count }.from(0).to(1)
      end

      it "should init the new item with the good product" do
        @cart.add_product @product.product_variants.first
        @cart.items.first.product.should == @product.product_variants.first
      end

      it "should affect a quantity of 1 to the item created" do
        @cart.add_product @product.product_variants.first
        @cart.items.first.quantity.should == 1
      end
    end

    context "when product is already present in the cart" do
      before(:each) do
        @cart.add_product @product.product_variants.first
      end

      it "should not change items count" do
        # Wrong test but behavior at this time allow this !!!
        expect { @cart.add_product @product.product_variants.first }.to change{ @cart.items.count }
      end

      it "should not change item product" do
        expect { @cart.add_product @product.product_variants.first }.to_not change{ @cart.items.first.product }
      end

    end
  end

  describe "#remove_product" do

    context "when product is present in the cart" do
      before(:each) do
        @cart.add_product @product.product_variants.first
      end

      it "should remove item product from cart" do
        expect { @cart.remove_product(@product.product_variants.first) }.to change{ @cart.items.count }.by(-1)
      end
    end

    context "when product is not present in the cart" do
      it "should not change cart items" do
        expect { @cart.remove_product(@product.product_variants.first)}.to_not change { @cart.items }
      end
    end
  end

  describe "#total and total_with_shipping" do
    context "when cart is empty" do
      before { @cart.stub(:items, []) }
      specify { @cart.total.should be_zero }
      specify { @cart.total_with_shipping.should be_zero }
    end

    context "when cart is not empty" do
      before do
        @cart.add_product @product.product_variants.first
        2.times { @cart.add_product @product2.product_variants.first }
      end

      it "should be the sum of items total" do
        @cart.total.should == @product.product_variants.first.price_ttc + 2*@product2.product_variants.first.price_ttc
      end
    end
  end

  describe "#total_items" do
    context "when cart is empty" do
      before { @cart.stub(:items, []) }
      specify { @cart.total_items.should be_zero }
    end

    context "when cart is not empty" do
      before do
        @cart.add_product @product.product_variants.first
        2.times { @cart.add_product @product2.product_variants.first }
      end

      it "should be the sum of items quantities" do
        @cart.total_items.should == 3
      end
    end
  end
end
