require 'spec_helper'

describe LineItem do
  before(:all) do
    @line_item = create(:line_item)
    @empty_line_item = create(:line_item, :quantity => 0)
  end

  it { should allow_mass_assignment_of(:quantity) }
  it { should allow_mass_assignment_of(:price) }
  it { should allow_mass_assignment_of(:product_variant_id) }
  it { should_not allow_mass_assignment_of(:order_id) }

  it { should belong_to(:order) }
  it { should belong_to(:product_variant) }
  it { should have_one(:product).through(:product_variant) }

  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:product_variant) }

  it { should validate_numericality_of(:quantity).with_message('must be int') }
  it { should allow_value(1).for(:quantity) }
  it { should_not allow_value(1.42).for(:quantity) }
  it { should_not allow_value(-1).for(:quantity) }
  it { should validate_numericality_of(:price) }
  it { should allow_value(42.42).for(:price) }
  it { should_not allow_value(-1).for(:price) }

  describe "#increment_quantity" do
    it { expect {@line_item.increment_quantity}.to change{@line_item.quantity}.by(1) }
  end

  describe "#decrement_quantity" do
    it { expect {@line_item.decrement_quantity}.to change{@line_item.quantity}.by(-1) }
    it { expect {@empty_line_item.decrement_quantity}.to_not change{@empty_line_item.quantity} }
  end

  describe "#amount" do
    subject { @line_item.amount }
    it { should eq(@line_item.quantity*@line_item.price) }
  end

  describe "#total" do
    subject { @line_item.total }
    it { should eq(@line_item.quantity*@line_item.price) }
  end
end
