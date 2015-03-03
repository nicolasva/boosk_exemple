class CreateProductFeeds < ActiveRecord::Migration
  def change
    create_table :product_feeds do |t|
      t.string :url, :null => false
      t.references :shop
      t.timestamps
    end

    add_index :product_feeds, :shop_id, :unique => true
  end
end
