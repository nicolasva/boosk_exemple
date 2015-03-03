class PromotionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  # GET /shops/1/promotions
  # GET /shops/1/promotions.json
  def index
    @promotions = @shop.promotions

    respond_to do |format|
      format.html
      format.json { render json: @promotions }
    end
  end

  def show
    @promotion = @shop.promotions.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @promotion }
    end
  end

  # GET /shops/1/promotions/new
  # GET /shops/1/promotions/new.json
  def new
    @promotion = @shop.promotions.build

    respond_to do |format|
      format.html     
      format.json { render json: @promotion }
    end
  end

  # POST /shops/1/promotions
  # POST /shops/1/promotions.json
  def create
    promotion_rules = params[:promotion].delete(:promotion_rules_attributes)
    @promotion = @shop.promotions.build params[:promotion]
    @promotion.promotion_rules << ProductGroupPromotionRule.new(promotion_rules.first) unless promotion_rules.nil?

    respond_to do |format|
      if @promotion.save
        format.html { redirect_to shop_promotions_path(@shop), notice: 'Promotion was successfully created.' }
        format.json { render json: @promotion, status: :created, location: shop_promotion_url(@promotion.shop, @promotion) }
      else
        format.html { render action: "new" }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /shops/1/promotions/1/edit
  def edit
    @promotion = @shop.promotions.find params[:id]
  end

  # PUT /shops/1/promotions/1
  # PUT /shops/1/promotions/1.json
  def update
    @promotion = @shop.promotions.find params[:id]
    promotion_rules = params[:promotion].delete(:promotion_rules_attributes)
    @promotion.promotion_rules = [ProductGroupPromotionRule.new(promotion_rules.first)] unless promotion_rules.nil?

    respond_to do |format|
      if @promotion.update_attributes(params[:promotion])
        format.html { redirect_to shop_promotions_path(@shop), notice: 'Promotion was successfully updated.' }
        format.json { render json: @promotion }
      else
        format.html { render action: "edit" }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1/promotion/1
  # DELETE /shops/1/promotion/1.json
  def destroy
    @promotion = @shop.promotions.find params[:id]
    @promotion.destroy

    respond_to do |format|
      format.html { redirect_to shop_promotions_path(@shop) }
      format.json { render json: @promotion }
    end
  end

  # DELETE /shops/1/tax_rates/all
  # DELETE /shops/1/tax_rates/all.json
  def destroy_all
    @promotions = Promotion.destroy(params[:ids])

    respond_to do |format|
      format.json { render json: @promotions }
    end
  end
end