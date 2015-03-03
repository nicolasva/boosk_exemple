require 'spec_helper'

describe OptionType do
  it { should belong_to(:shop) }
  it { should have_and_belong_to_many(:product_variants) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:value) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }

  subject { create(:option_type) }
  it { should be_valid }

  describe "by_key scope" do
    before(:each) do
      @option_type1 = create(:option_type, :name => "Option1")
      @option_type2 = create(:option_type, :name => "Option2")
    end

    subject { OptionType.by_key "Option1" }
    it { should include(@option_type1) }
    it { should_not include(@option_type2) }
  end

  describe "#group_by_key" do
    before(:each) do
      OptionType.destroy_all
      @option_type1 = create(:option_type, :name => "Option1", :value => "Value1")
      @option_type2 = create(:option_type, :name => "Option1", :value => "Value2")
      @option_type3 = create(:option_type, :name => "Option2", :value => "Value1")
    end

    subject { OptionType.group_by_key }
    it { should eq( [ { :type => "Option1", :values => [ @option_type1, @option_type2 ] },
                      { :type => "Option2", :values => [ @option_type3 ]} ] ) }
  end

  it { expect { OptionType.create_by_key({:name => "Option1", :value => ["Value1", "Value2"]}, create(:shop).id.to_s) }.to change{OptionType.count}.by(2) }

  describe "#update_by_key" do
    before(:each) do
      @optiontype = create(:option_type, :value => "init_value")
      @params = {:name => @optiontype.name, :option => [{:id => @optiontype.id, :value => "test"}, {:value => "test2"} ] }
    end

    it { expect { OptionType.update_by_key(@params, @optiontype.id) }.to change{@optiontype.reload.value}.from("init_value").to("test") }
    it { expect { OptionType.update_by_key(@params, @optiontype.id) }.to change{OptionType.count}.by(1) }
  end
end
