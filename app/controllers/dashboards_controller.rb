class DashboardsController < ApplicationController
  caches_action  :translate, :geographic_regions
  before_filter :authenticate_user!, except: [:translate, :geographic_regions]
  before_filter :check_plans, except: [:show, :translate]
  before_filter :check_shop_authorize, except: [:show, :translate, :geographic_regions]
  include RestGraph::RailsUtil
  
  def show
    if current_user.plan.nil?
      redirect_to(plans_path)
    else
      unless current_user.shops.empty?
        respond_to do |format|
          format.html
          format.json { render json: current_user }
        end
      else
        redirect_to(wizards_path)
      end
    end
  end

  def shop_functionnality
    shop = Shop.find_by_uuid(cookies[:shop_id])
    @functionnality = {
      :zones => shop.zones.any?,
      :taxes => shop.tax_rates.any?,
      :shipping_methods => shop.shipping_methods.any?,
      :taxons => (shop.taxonomies.first.taxons.count > 1),
      :products => shop.products.any?,
      :paypal_account => (shop.paypal_account != nil),
      :customization => shop.customization.logo.nil?
    }

    respond_to do |format|
      format.json { render json: @functionnality.to_json }
    end
  end

  def translate
    I18n.backend.send(:init_translations)
    translations = I18n.backend.send(:translations)

    respond_to do |format|
      format.json { render json: translations[:"#{I18n.locale}"] }
    end
  end

  def general_analytics
    shop = Shop.find_by_uuid(cookies[:shop_id])
    from = params[:from] != nil ? Time.parse("#{params[:from]} 00:00:00 UTC") : (Time.now.beginning_of_day - 6.day).utc
    to = params[:to] != nil ? Time.parse("#{params[:to]} 23:59:59 UTC") : Time.now.utc

    @shop_earning = shop.orders.not_unpaid.sum(:total)
    @nb_products = shop.products.count
    @top_products_by_action = {}
    shop_trackers = ShopTracker.where(:ref => shop.uuid, 'trackers.created_at' => { :$gte => from, :$lte => to})

    if shop_trackers.exists?
      @shop_views = shop_trackers.sum(:trackers).count

      @general_products_stats = ProductTracker.where(:shop_uid => shop.uuid, 'trackers.created_at' =>
                                      { :$gte => from, :$lte => to}).count_by_action

      @last_orders = OrderTracker.where(:shop_uid => shop.uuid, 'trackers.created_at' =>
                                      { :$gte => from, :$lte => to}).desc(:created_at).limit(5)

      @order_stats = shop.orders.not_unpaid.where(:created_at => from..to).count(:group => "workflow_state")

      if current_user.plan.has_analytics
        ProductTracker::ACTIONS.each do |action|
          products = ProductTracker.where(:shop_uid => shop.uuid, 'trackers.created_at' =>
                                          { :$gte => from, :$lte => to}).top_by_action(action).take(10).map { |p|
            {
              :product => Product.eager_loading.find_by_uuid(p['value']['ref']).as_json(:include => {:product_variants => {:include => [:pictures]}}),
              :count => p['value']['count']
            }
          }
          @top_products_by_action[action] = products
        end
      else
        @top_products_by_action[:forbidden] = true
      end
    else
      @top_products_by_action[:forbidden] = true unless current_user.plan.has_analytics
    end

    respond_to do |format|
      format.html
      format.json { render json: {
          shop_views: @shop_views,
          top_products_by_action: @top_products_by_action,
          order_stats: @order_stats,
          last_orders: @last_orders,
          shop_earning: @shop_earning,
          general_products_stats: @general_products_stats,
          nb_products: @nb_products
        }
      }
    end
  end

  def geographic_regions
    respond_to do |format|
      format.json { render json: carmen_regions }
    end
  end


  def update
    rest_graph_setup(
      :app_id => BOOSKETSHOPS['facebook']['app_id'],
      :secret => BOOSKETSHOPS['facebook']['app_secret'],
      :display => 'popup',
      :auto_authorize_scope => 'user_about_me,email')

    rest_graph.get('me', :async => true) { |data|
      facebook_token = rest_graph['data']['access_token']
      current_user.update_attributes(:facebook_uid => data['id'])
      current_user.update_attributes(:facebook_token => facebook_token)
    }

    respond_to do |format|
      format.html { redirect_to dashboard_url }
      format.json { render json: current_user }
    end
  end

  private
    def carmen_regions
      Rails.cache.fetch([:carmen_regions, I18n.locale], expires_in: 7.days) do
        Carmen.reset_i18n_backend
        Carmen.i18n_backend.locale = I18n.locale
        Carmen::Country.all.collect do |r|
          {
            name: r.name,
            code: r.code,
            type: r.type,
            subregions: r.subregions.collect do |s|
              {
                name: s.name,
                code: "#{r.code}|#{s.code}",
                type: s.type
              }
            end
          }
        end
      end
    end
end
