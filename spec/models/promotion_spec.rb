require 'spec_helper'

describe Promotion do
  it { should_not allow_mass_assignment_of(:shop_id) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:coupon_code) }
  it { should allow_mass_assignment_of(:free_shipping) }
  it { should allow_mass_assignment_of(:percent_discount) }
  it { should allow_mass_assignment_of(:discount_amount) }
  it { should allow_mass_assignment_of(:starts_at) }
  it { should allow_mass_assignment_of(:ends_at) }

  it { should belong_to(:shop) }
  it { should have_many(:promotion_rules) }

  describe "free_shipping scope" do
    it "includes promotions with free shipping" do
      @promotion = create(:promotion, :free_shipping => true)
      Promotion.free_shipping.should include(@promotion)
    end

    it "excludes promotions which do not have free shipping" do
      @promotion = create(:promotion, :free_shipping => false)
      Promotion.free_shipping.should_not include(@promotion)
    end
  end

  describe "product_discount scope" do
    it "includes promotions which do not have free shipping" do
      @promotion = create(:promotion, :free_shipping => false)
      Promotion.product_discount.should include(@promotion)
    end

    it "excludes promotions with free shipping" do
      @promotion = create(:promotion, :free_shipping => true)
      Promotion.product_discount.should_not include(@promotion)
    end
  end

  describe "starting_before scope" do
    before(:each) do
      @specified_date = DateTime.now + 1.month
    end

    it "includes promotions starting before the specified date" do
      @promotion = create(:promotion, :starts_at => @specified_date - 1.second)
      Promotion.starting_before(@specified_date).should include(@promotion)
    end

    it "excludes promotions starting after the specified date" do
      @promotion = create(:promotion, :starts_at => @specified_date + 1.second)
      Promotion.starting_before(@specified_date).should_not include(@promotion)
    end
  end

  describe "ending_after scope" do
    before(:each) do
      @specified_date = Time.now + 1.month
    end

    it "includes promotions ending after the specified date" do
      @promotion = create(:promotion, :ends_at => @specified_date + 1.second)
      Promotion.ending_after(@specified_date).should include(@promotion)
    end

    it "includes promotions with no end date (unlimited promotions)" do
      @promotion = create(:promotion, :ends_at => nil)
      Promotion.ending_after(@specified_date).should include(@promotion)      
    end

    it "excludes promotions starting after the specified date" do
      @promotion = create(:promotion, :ends_at => @specified_date - 1.second)
      Promotion.ending_after(@specified_date).should_not include(@promotion)
    end
  end

  describe "current scope" do
    it "excludes promotions already ended" do
      @promotion = create(:promotion, :starts_at => Time.now - 1.month, :ends_at => Time.now - 1.second)
      Promotion.current.should_not include(@promotion)
    end

    it "excludes promotions not started" do
      @promotion = create(:promotion, :starts_at => Time.now + 1.second)
      Promotion.current.should_not include(@promotion)
    end

    it "includes promotions already started which end in the future" do
      @promotion = create(:promotion, :starts_at => Time.now - 1.second, :ends_at => Time.now + 1.second)
      Promotion.current.should include(@promotion)
    end

    it "includes promotions already started with no end date" do
      @promotion = create(:promotion, :starts_at => Time.now - 1.second, :ends_at => nil)
      Promotion.current.should include(@promotion)
    end
  end

  describe "#promotion_dates_validation" do
    it "should add an error if starts_at is not a date" do
      @promotion = build(:promotion)
      @promotion.stub(:starts_at) { "test" }
      @promotion.promotion_dates_validation
      @promotion.errors[:starts_at].should be_present
    end

    it "should not add an error if starts_at is a date" do
      @promotion = build(:promotion, :starts_at => Time.now)
      @promotion.promotion_dates_validation
      @promotion.errors.should be_blank
    end

    it "should not add an error if starts_at is blank" do
      @promotion = build(:promotion, :starts_at => nil)
      @promotion.promotion_dates_validation
      @promotion.errors.should be_blank
    end

    it "should add an error if ends_at is not a date" do
      @promotion = build(:promotion)
      @promotion.stub(:ends_at) { "test" }
      @promotion.promotion_dates_validation
      @promotion.errors[:ends_at].should be_present
    end

    it "should add an error if ends_at is earlier than starts_at" do
      @promotion = build(:promotion, :starts_at => Time.now, :ends_at => Time.now - 1.month)
      @promotion.promotion_dates_validation
      @promotion.errors[:ends_at].should be_present
    end

    it "should not add an error if ends_at is later than starts_at" do
      @promotion = build(:promotion, :starts_at => Time.now, :ends_at => Time.now + 1.month)
      @promotion.promotion_dates_validation
      @promotion.errors.should be_blank
    end
  end

  describe "validation" do
    it "should run promotion_dates_validation " do
      @promotion = build(:promotion)
      @promotion.should_receive :promotion_dates_validation
      @promotion.valid?
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starts_at) }
    it { should ensure_inclusion_of(:free_shipping).in_array([true, false]) }
    it { should ensure_inclusion_of(:percent_discount).in_array([true, false]) }

    context "with free shipping" do
      subject { build(:promotion, :free_shipping => true) }
      it { should allow_value(nil).for(:discount_amount) }
      it { should allow_value("test").for(:discount_amount) }
      it { should allow_value(-1).for(:discount_amount) }
      it { should allow_value(101).for(:discount_amount) }
      it { should allow_value(42.42).for(:discount_amount) }
    end

    context "with product discount" do
      context "and percent discount off" do
        subject { build(:promotion, :free_shipping => false, :percent_discount => false) }
        it { should_not allow_value(nil).for(:discount_amount) }
        it { should_not allow_value("test").for(:discount_amount) }
        it { should_not allow_value(-1).for(:discount_amount) }
        it { should allow_value(101).for(:discount_amount) }
        it { should allow_value(42.42).for(:discount_amount) }
      end

      context "and percent discount on" do
        subject { build(:promotion, :free_shipping => false, :percent_discount => true) }
        it { should_not allow_value(nil).for(:discount_amount) }
        it { should_not allow_value("test").for(:discount_amount) }
        it { should_not allow_value(-1).for(:discount_amount) }
        it { should_not allow_value(101).for(:discount_amount) }
        it { should allow_value(42.42).for(:discount_amount) }
      end
    end
  end
end
