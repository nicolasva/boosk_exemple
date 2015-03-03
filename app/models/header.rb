class Header < ActiveRecord::Base
  attr_accessible :offset, :picture, :cached_name

  belongs_to :customization

  mount_uploader :picture, HeaderUploader

  def cached_name=(path)
    if path && path.is_a?(String)
      uploader = HeaderUploader.new 
      uploader.retrieve_from_cache!(path)
      self.picture = File.open("#{Rails.root}/public#{uploader.to_s}")
      uploader.remove!
    end
  end
end
