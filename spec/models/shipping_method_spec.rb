require 'spec_helper'

describe ShippingMethod do
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:zone_id) }
  it { should allow_mass_assignment_of(:shipping_category_id) }
  it { should allow_mass_assignment_of(:match_none) }
  it { should allow_mass_assignment_of(:match_one) }
  it { should allow_mass_assignment_of(:match_all) }
  it { should allow_mass_assignment_of(:calculator_type) }
  it { should allow_mass_assignment_of(:calculator_attributes) }
  it { should_not allow_mass_assignment_of(:shop_id) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }
  it { should_not allow_mass_assignment_of(:calculator) }

  it { should belong_to(:shop) }
  it { should belong_to(:shipping_category) }
  it { should belong_to(:zone) }

  it { should have_one(:calculator).dependent(:destroy) }

  it { should accept_nested_attributes_for(:calculator) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:zone) }
  it { should validate_presence_of(:calculator) }

  describe "#available_to_order?" do
    before(:each) do
      @shipping_method = create(:shipping_method)
      @shipping_method.zone.stub(:include? => true)
      @order = create(:order)
    end

    context "when order is not specified" do
      it "should not be available" do
        @shipping_method.available_to_order?(nil).should be_false
      end
    end

    context "when order address is not included in shipping method's zone" do
      before { @shipping_method.zone.stub(:include? => false) }

      it "should not be available" do
        @shipping_method.available_to_order?(@order).should be_false
      end
    end

    context "when order and shipping method's shipping categories don't match" do
      before { @shipping_method.stub(:category_match? => false) }

      it "should not be available" do
        @shipping_method.available_to_order?(@order).should be_false
      end
    end

    context "when address is included in zone and shipping categories match" do
      it "should be available" do
        @shipping_method.available_to_order?(@order).should be_true
      end
    end
  end

  describe "#category_match?" do
    context "when no category is specified" do
      before(:each) do
        @shipping_method = create(:shipping_method)
        @order = create(:order)
      end

      it "should return true" do
        @shipping_method.category_match?(@order).should be_true
      end
    end

    context "when a category is specified" do
      before(:each) do
        @shipping_method = create(:shipping_method_with_category)
      end

      context "when all products match" do
        before(:each) do
          variant = create(:product_variant, :product => create(:product, :shipping_category => @shipping_method.shipping_category))
          @order = create(:order, :line_items => [create(:line_item, :product_variant => variant)])
        end

        context "when rule is every match" do
          before { @shipping_method.match_all = true }

          it "should return true" do
            @shipping_method.category_match?(@order).should be_true
          end
        end

        context "when rule is at least one match" do
          before { @shipping_method.match_one = true }

          it "should return true" do
            @shipping_method.category_match?(@order).should be_true
          end
        end

        context "when rule is none match" do
          before { @shipping_method.match_none = true }

          it "should return false" do
            @shipping_method.category_match?(@order).should be_false
          end
        end
      end

      context "when no products match" do
        before(:each) do
          variant = create(:product_variant, :product => create(:product, :shipping_category => create(:shipping_category)))
          @order = create(:order, :line_items => [create(:line_item, :product_variant => variant)])
        end

        context "when rule is every match" do
          before { @shipping_method.match_all = true }

          it "should return false" do
            @shipping_method.category_match?(@order).should be_false
          end
        end

        context "when rule is at least one match" do
          before { @shipping_method.match_one = true }

          it "should return false" do
            @shipping_method.category_match?(@order).should be_false
          end
        end

        context "when rule is none match" do
          before { @shipping_method.match_none = true }

          it "should return true" do
            @shipping_method.category_match?(@order).should be_true
          end
        end
      end

      context "when some products match" do
        before(:each) do
          variant1 = create(:product_variant, :product => create(:product, :shipping_category => @shipping_method.shipping_category))
          variant2 = create(:product_variant, :product => create(:product, :shipping_category => create(:shipping_category)))
          @order = create(:order, :line_items => [create(:line_item, :product_variant => variant1), create(:line_item, :product_variant => variant2)])
        end

        context "when rule is every match" do
          before { @shipping_method.match_all = true }

          it "should return false" do
            @shipping_method.category_match?(@order).should be_false
          end
        end

        context "when rule is at least one match" do
          before { @shipping_method.match_one = true }

          it "should return true" do
            @shipping_method.category_match?(@order).should be_true
          end
        end

        context "when rule is none match" do
          before { @shipping_method.match_none = true }

          it "should return false" do
            @shipping_method.category_match?(@order).should be_false
          end
        end
      end
    end
  end

end
