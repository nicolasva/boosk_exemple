class AddFacebookPageTokenToShop < ActiveRecord::Migration
  def change
    add_column :shops, :facebook_page_token, :string

  end
end
