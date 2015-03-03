require 'spec_helper'

describe ProductVariant do
  it { should allow_mass_assignment_of(:sku) }
  it { should allow_mass_assignment_of(:price) }
  it { should allow_mass_assignment_of(:weight) }
  it { should allow_mass_assignment_of(:height) }
  it { should allow_mass_assignment_of(:width) }
  it { should allow_mass_assignment_of(:depth) }
  it { should allow_mass_assignment_of(:quantity) }
  it { should allow_mass_assignment_of(:deleted_at) }
  it { should allow_mass_assignment_of(:is_master) }
  it { should allow_mass_assignment_of(:pictures) }
  it { should_not allow_mass_assignment_of(:line_items) }
  it { should_not allow_mass_assignment_of(:product_id) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }

  it { should belong_to(:product) }
  it { should have_many(:line_items) }
  it { should have_many(:pictures).class_name("ProductVariantPicture").dependent(:destroy) }
  it { should have_and_belong_to_many(:option_types)}

  it { should validate_presence_of(:price) }

  describe "scopes" do
    before(:all) do
      @active = create(:product_variant, :deleted_at => nil)
      @deleted = create(:product_variant, :deleted_at => Time.now)
      @master = create(:product_variant, :is_master => true)
    end

    describe "#active" do
      subject { ProductVariant.active }
      it { should include(@active) }
      it { should_not include(@deleted) }
    end

    describe "#deleted" do
      subject { ProductVariant.deleted }
      it { should_not include(@active) }
      it { should include(@deleted) }
    end

    describe "#master" do
      subject { ProductVariant.master }
      it { should include(@master) }
    end
  end
end
