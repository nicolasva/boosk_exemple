require 'spec_helper'

describe Order do
  it { should allow_mass_assignment_of(:number) }
  it { should allow_mass_assignment_of(:item_total) }
  it { should allow_mass_assignment_of(:total) }
  it { should allow_mass_assignment_of(:completed_at) }
  it { should allow_mass_assignment_of(:credit_total) }
  it { should allow_mass_assignment_of(:payment_total) }
  it { should allow_mass_assignment_of(:payment_state) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:special_instructions) }
  it { should allow_mass_assignment_of(:paid) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }

  it { should belong_to(:shop) }
  it { should have_many(:line_items).dependent(:destroy) }

  it { should accept_nested_attributes_for(:line_items) }

  context "workflow_state" do
    before(:each) do
      @order = create(:order)
      @contact = create(:contact, :contactable_type => "Order", :contactable_id => @order.id)
      @contact.emails << create(:contact_email, :contact_id => @contact.id)
      Order.any_instance.stub(:pay).and_return(true)
      Order.any_instance.stub(:shipping).and_return(true)
      Order.any_instance.stub(:deliver).and_return(true)
      Order.any_instance.stub(:cancel).and_return(true)
    end

    it "initial order state should be unpaid" do
      @order.unpaid?.should be_true
    end

    it "change state should be change workflow state" do
      @order.pay!
      @order.paid?.should be_true
      @order.shipping!
      @order.shipped?.should be_true
      @order.deliver!
      @order.delivered?.should be_true
      @order.cancel!
      @order.canceled?.should be_true
    end

  end
end
