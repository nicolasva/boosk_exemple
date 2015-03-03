class AnalyticsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize
  before_filter :check_authorization


  def index
    shop = Shop.eager_loading.find_by_uuid(params[:shop_id])

    from = params[:from] != nil ? Time.parse("#{params[:from]} 00:00:00 UTC") : (Time.now.beginning_of_day - 6.day)
    to = params[:to] != nil ? Time.parse("#{params[:to]} 23:59:59 UTC") : Time.now

    if ProductTracker.exists?
      if !params[:taxon_id].nil?
        self_and_descendants = shop.taxons.find(params[:taxon_id]).self_and_descendants.map(&:id)
        filtered_products = shop.products.includes(:taxons).where("taxons.id IN (?)",self_and_descendants)

        @products_charts = ProductTracker.where(:shop_uid => shop.uuid, :ref.in => filtered_products.map(&:uuid), 'trackers.created_at' =>
                                                { :$gte => from, :$lte => to}).count_by_date

        @products_kpis = filtered_products.map { |p|
          {
            :product => p.as_json(:include => {:product_variants => {:include => [:pictures]}}),
            :kpis => ProductTracker.where(:ref => p.uuid, 'trackers.created_at' => { :$gte => from, :$lte => to}).count_by_action
          }
        }
      elsif !params[:product_ids].nil?
        @products_charts = ProductTracker.where(:shop_uid => shop.uuid, :ref.in => params[:product_ids], 'trackers.created_at' =>
                                                { :$gte => from, :$lte => to}).count_by_date

        @products_kpis = shop.products.where(:uuid => params[:product_ids]).map { |p|
          {
            :product => p.as_json(:include => {:product_variants => {:include => [:pictures]}}),
            :kpis => ProductTracker.where(:ref => p.uuid, 'trackers.created_at' => { :$gte => from, :$lte => to}).count_by_action
          }
        }
      else
        @products_charts = ProductTracker.where(:shop_uid => shop.uuid, 'trackers.created_at' =>
                                                { :$gte => from, :$lte => to}).count_by_date

        @products_kpis = shop.products.eager_loading.map { |p|
          {
            :product => p.as_json(:include => {:product_variants => {:include => [:pictures]}}, :methods => [:taxon_ids]),
            :kpis => ProductTracker.where(:ref => p.uuid, 'trackers.created_at' => { :$gte => from, :$lte => to}).count_by_action
          }
        }
      end
    end

    if shop.orders.not_unpaid.any?
      @category_charts = {}
      shop.taxons.each do |taxon|
        items = LineItem.by_taxon(shop,taxon)
        items.each do |item|
          count = item.price_ttc.to_f.round(2)
          date = "#{item.created_at.beginning_of_day.to_i}000".to_i
          name = taxon.first_level.name.upcase
          if @category_charts.has_key?(name)
            category_by_date = @category_charts[name].select {|f| f[:value][:date] == date}.try(:first)
            unless category_by_date.nil?
              category_by_date[:value][:count] += count
            else
              @category_charts[name] << {:value => {:category => name, :count => count, :date => date}}
            end
          else
            @category_charts[name] = [{:value => {:category => name, :count => count, :date => date}}]
          end
        end
      end
    end

    if ShopTracker.exists?
      @shop_charts = ShopTracker.where(:ref => shop.uuid,'trackers.created_at' =>
                                       { :$gte => from, :$lte => to}).count_by_date
      @shop_charts['income'] = []

      shop.orders.not_unpaid.map{|o| {:order => o, :date => o.created_at.beginning_of_day.to_time.to_i}}.group_by{|t| t[:date]}.each_pair do |key, values|
        count = values.count > 1 ? values.inject{|sum,x| sum[:order].total.to_f + x[:order].total.to_f }.round(2) : values.first[:order].total.to_f.round(2)
        @shop_charts['income'] << {:value => {:count => count,:date => "#{key}000".to_i}}
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: {
          products_charts: @products_charts,
          shop_charts: @shop_charts,
          order_charts: @order_charts,
          products_kpis: @products_kpis,
          category_charts: @category_charts
        }
      }
    end
  end

  private
    def check_authorization
      unless current_user.plan.has_analytics
        render :text => "You do not have access to this service", :status => :forbidden
      end
    end

end
