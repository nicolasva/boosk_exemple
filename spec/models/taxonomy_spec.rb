require 'spec_helper'

describe Taxonomy do
  it { should allow_mass_assignment_of(:name) }
  it { should_not allow_mass_assignment_of(:shop_id) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }

  it { should validate_presence_of(:name) }

  it { should belong_to(:shop) }
  it { should have_many(:taxons) }
  it { should have_one(:root).class_name("Taxon") }

  describe "after_save" do
    it "runs the proper callbacks" do
      @taxonomy = build(:taxonomy)
      @taxonomy.should_receive(:set_root)
      @taxonomy.run_callbacks(:save) { true }
    end
  end

  describe "#set_root" do
    context "when taxonomy has no root" do
      before(:each) do
        @taxonomy = build(:taxonomy, :root => nil)
      end

      it "creates a new Taxon with taxonomy name" do
        Taxon.should_receive(:create!).with({ :taxonomy_id => @taxonomy.id, :name => @taxonomy.name }, :without_protection => true)
        @taxonomy.set_root
      end

      it "sets new Taxon as taxonomy's root" do
        @taxon = create(:taxon)
        Taxon.stub(:create!).and_return(@taxon)
        @taxonomy.set_root
        @taxonomy.root.should be(@taxon)
      end
    end

    context "when taxonomy has already a root" do
      before(:each) do
        @taxonomy = build(:taxonomy, :root => create(:taxon))
      end

      it "does not create any Taxon" do
        expect { @taxonomy.set_root }.to_not change{ Taxon.count }
      end

      it "updates root name to taxonomy name" do
        @taxonomy.set_root
        @taxonomy.root.name.should be(@taxonomy.name)
      end
    end
  end
end