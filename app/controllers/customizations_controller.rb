class CustomizationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize
  before_filter :check_authorization, :only => [:edit,:update]


  # GET /shops/1/customization
  # GET /shops/1/customization.json
  def show
    @shop = Shop.find_by_uuid(params[:shop_id])
    @shop.create_customization unless @shop.customization
    @customization = @shop.customization

    if stale?(@shop)
      respond_to do |format|
        format.html
        format.json { render json: @customization }
      end
    end
  end

  # GET /shops/1/customization/edit
  def edit
    @shop = Shop.find_by_uuid(params[:shop_id])
    @shop.create_customization unless @shop.customization
    @customization = @shop.customization
  end

  # PUT /shops/1/customization
  # PUT /shops/1/customization.json
  def update
    @shop = Shop.find_by_uuid(params[:shop_id])
    @shop.create_customization unless @shop.customization
    @customization = @shop.customization
    @customization.upload :logo=, params[:logo], LogoUploader.new
    @customization.upload :teaser=, params[:teaser], TeaserUploader.new
    @customization.upload :shutter=, params[:shutter], ShutterUploader.new

    respond_to do |format|
      if @customization.update_attributes(params[:customization])
        format.html { redirect_to shop_customization_path(@shop), notice: 'Shop customization was successfully updated.' }
        format.json { render json: @customization, status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @customization.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def check_authorization
      unless current_user.plan.has_customization
        render :text => "You do not have access to this service", :status => :forbidden
      end
    end

end
