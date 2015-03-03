class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string  :uuid,       :limit => 36,   :null => false
      t.string  :slug,                       :null => false
      t.string  :name,                       :null => false
      t.string  :baseline
      t.text    :description
      t.text    :terms
      t.string  :url_website

      t.string  :devise

      t.boolean :has_active_payement,    :default => true

      t.string  :fan_page_id
      t.string  :google_shopping_key
      t.string  :paypal_account

      t.boolean :facebook_status,        :default => false
      t.boolean :mobile_status,          :default => false
      t.boolean :google_shopping_status, :default => false
      t.boolean :web_status,             :default => false
      t.boolean :tv_status,              :default => false

      t.string  :data_product_feed_url

      t.timestamps
      t.references :user
    end

    add_index :shops, :uuid
    add_index :shops, :slug
    add_index :shops, :facebook_status
    add_index :shops, :mobile_status
    add_index :shops, :google_shopping_status
    add_index :shops, :web_status
    add_index :shops, :tv_status
    add_index :shops, :user_id
  end
end
