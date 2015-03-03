class AttachmentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans

  def create
    @uploader = case params[:attachment_type]
      when "logo" then LogoUploader.new
      when "header" then HeaderUploader.new
      when "footer" then FooterUploader.new
      when "shutter" then ShutterUploader.new
      when "teaser" then TeaserUploader.new
      when "tab_thumbnail" then TabThumbnailUploader.new
      else ProductVariantPictureUploader.new
    end

    @uploader.cache!(params[:file]) unless params[:file].nil?

    respond_to do |format|
      if @uploader.cached?
        format.js {render json: {:url => @uploader.to_s, :cached_name => @uploader.cache_name}}
      else
        format.js {render inline: "",  :status => 406}
      end
    end
  end
end
