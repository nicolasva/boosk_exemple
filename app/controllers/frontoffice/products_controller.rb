class Frontoffice::ProductsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :set_cookies
  before_filter :get_shop_from_subdomain

  def index
    if params[:query]
      @products = @shop.products.where(:status => true).where("name like '%?%'", params[:query]).order(:position).limit("#{params[:page]},#{params[:product_per_page]}")
    elsif params[:taxon_id]
      @taxon = Taxon.find(params[:taxon_id])
      @products = @shop.products.where(:status => true).joins(:taxons).where("taxons.id IN (?)", @taxon.self_and_descendants).order(:position).limit("#{params[:page]},#{params[:product_per_page]}")
    else
      @products = @shop.products.where(:status => true).order(:position).limit("#{params[:page]},#{params[:product_per_page]}")
    end

    respond_to do |format|
      format.html
      format.json { render json: @products.to_json(:include => {:shop => {:include => :customization}, :product_variants => {:methods => :price_ttc, :include => [:option_types,:pictures]}}) }
    end
  end

  def show
    @product = Product.eager_loading.find(:first, :conditions => ["uuid = ? or slug = ?", params[:id], params[:id]])

    @shop_option_types = @product.shop.option_types.group_by_key
    @customization = @product.shop.customization

    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @product.to_json(:include => {:shop => {:include => :customization}, :product_variants => {:methods => :price_ttc, :include => [:option_types,:pictures]}}) }
    end
  end
end
