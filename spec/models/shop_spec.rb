require 'spec_helper'

describe Shop do

  it { should_not allow_mass_assignment_of(:uuid) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }
  it { should_not allow_mass_assignment_of(:user_id) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:baseline) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:terms) }
  it { should allow_mass_assignment_of(:url_website) }
  it { should allow_mass_assignment_of(:facebook_status) }
  it { should allow_mass_assignment_of(:mobile_status) }

  it { should allow_mass_assignment_of(:devise) }

  it { should have_and_belong_to_many(:users) }
  it { should have_many(:products).dependent(:destroy) }
  it { should have_one(:contact).dependent(:destroy) }
  it { should have_many(:option_types).dependent(:destroy) }
  it { should have_one(:customization).dependent(:destroy) }
  it { should have_many(:taxonomies).dependent(:destroy) }
  it { should have_many(:promotions).dependent(:destroy) }

  it { expect { create(:shop, :option_types_attributes => build(:option_type, :shop_id => nil).attributes ) }.to change{OptionType.count}.by(1) }

  it { should validate_presence_of(:name) }

  describe ".create" do
    it "should set UUID" do
      @shop = create(:shop)
      @shop.uuid.should be
    end
  end

  describe "scopes" do
    before(:all) do
      @openshop = create(:shop, :facebook_status => true)
      @closedshop = create(:shop, :facebook_status => false)
    end

    describe Shop.open do
      subject { Shop.open }
      it { should include(@openshop) }
      it { should_not include(@closedshop) }
    end

    describe Shop.close do
      subject { Shop.close }
      it { should_not include(@openshop) }
      it { should include(@closedshop) }
    end
  end
end
