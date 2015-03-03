class OptionTypesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  def index
    @option_types = @shop.option_types.group_by_key

    respond_to do |format|
      format.html
      format.json { render json: @option_types }
    end
  end

  def show
    @option_type = @shop.option_types.by_key(params[:id]).group_by_key.first

    respond_to do |format|
      format.html
      format.json { render json: @option_type }
    end
  end

  def new
    @option_type = OptionType.new

    respond_to do |format|
      format.html
      format.json { render json: @option_type }
    end
  end

  def edit
    @option_type = OptionType.by_key(params[:id]).group_by_key.first

    respond_to do |format|
      format.html
    end
  end

  def create
    shop = Shop.find_by_uuid params[:shop_id]

    respond_to do |format|
      if @option_types = OptionType.create_by_key(params[:option_type], shop.id)
        format.html { redirect_to shop_option_types_path(params[:shop_id]), notice: 'OptionType was successfully created.' }
        format.json { render json: @option_types, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @option_types.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    shop = Shop.find_by_uuid params[:shop_id]

    respond_to do |format|
      if @option_types = OptionType.update_by_key(params[:option_type], shop.id)
        format.html { redirect_to shop_option_types_path(params[:shop_id]), notice: 'OptionType was successfully updated.' }
        format.json { render json: @option_types }
      else
        format.html { render action: "edit" }
        format.json { render json: @option_types.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    respond_to do |format|
      ProductVariant.eager_loading.where("option_types.name" => params[:id]).destroy_all
      if @option_types = OptionType.by_key(params[:id]).destroy_all
        format.html { redirect_to shop_option_types_url }
        format.json { render json: @option_types }
      else
        format.html { redirect_to shop_option_types_url }
        format.json { render json: @option_types.errors }
      end
    end
  end

  # DELETE /shops/1/option_types/all
  # DELETE /shops/1/option_types/all.json
  def destroy_all
    Product.eager_loading.where("option_types.name" => params[:ids]).destroy_all
    @option_types = OptionType.destroy_all(name: params[:ids])

    respond_to do |format|
      format.json { render json: @option_types.group_by(&:name).collect {|name,values| {:type => name, :values => values}} }
    end
  end
end
