require 'spec_helper'

describe Product do
  before(:each) do
    @product = create(:product, :tax_rate_id => create(:tax_rate, :rate => 10))
    @inactiveproduct = create(:product, :deleted_at => Time.now, :tax_rate_id => create(:tax_rate, :rate => 10))
  end

  it { should allow_mass_assignment_of(:uuid) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:permalink) }
  it { should allow_mass_assignment_of(:shipping_category_id) }
  it { should allow_mass_assignment_of(:status) }
  it { should allow_mass_assignment_of(:highlight) }
  it { should allow_mass_assignment_of(:available_on) }
  it { should allow_mass_assignment_of(:taxon_ids) }
  it { should allow_mass_assignment_of(:deleted_at) }
  it { should allow_mass_assignment_of(:created_at) }
  it { should allow_mass_assignment_of(:updated_at) }

  it { should belong_to(:shop) }
  it { should belong_to(:shipping_category)}
  it { should have_many(:product_variants).dependent(:destroy) }
  it { should have_and_belong_to_many(:taxons) }  

  it { should validate_presence_of(:name) }

  it "should set master on first variant" do
    @product.product_variants.first.is_master.should be_true
  end

  #1 product variant is automagically created in product factory; the other should be created with :product_variants_attributes
  it { expect {create(:product, :product_variants_attributes => build(:product_variant).attributes)}.to change{ProductVariant.count}.by(2) }
  
  it { expect {@product.destroy}.to change{@product.product_variants.reload.count}.from(1).to(0) }

  describe "active scope" do
    subject { Product.active }
    it { should include(@product) }
    it { should_not include(@inactiveproduct) }
  end

  describe "deleted scope" do
    subject { Product.deleted }
    it { should_not include(@product) }
    it { should include(@inactiveproduct) }
  end
end
