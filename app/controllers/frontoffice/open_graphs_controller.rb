class Frontoffice::OpenGraphsController < ApplicationController
  include RestGraph::RailsUtil
  skip_before_filter :verify_authenticity_token, :set_cookies

  def create
    facebook_token = nil

    rest_graph_setup(
      :app_id => BOOSKETSHOPS['facebook']['app_id'],
      :secret => BOOSKETSHOPS['facebook']['app_secret'],
      :display => 'popup',
      :auto_authorize_scope => 'user_about_me,email,publish_stream'
    )

    rest_graph.get('me', :async => true) { |data|
      facebook_token = rest_graph['data']['access_token']
    }

    PostOGActionWorker.perform_async(params[:type].capitalize, params[:product_id], facebook_token)
    render :nothing => true
  end
end
