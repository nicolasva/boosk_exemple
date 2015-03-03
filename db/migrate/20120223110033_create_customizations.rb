class CreateCustomizations < ActiveRecord::Migration
  def change
    create_table :customizations do |t|
      t.integer :shop_id,                                                :null => false
      t.string  :background_color_shop,           :default => "#FFFFFF", :null => false
      t.string  :background_color_product_list,   :default => "#ECECEC", :null => false
      t.string  :background_color_product_thumb,  :default => "#FFFFFF", :null => false
      t.string  :background_color_sidebar,        :default => "#2F2F2F", :null => false
      t.string  :background_color_sidebar_item,   :default => "#FFFFFF", :null => false
      t.string  :baseline_color,                  :default => "#1D4088", :null => false
      t.string  :border_color,                    :default => "#DADADA", :null => false
      t.string  :color_text,                      :default => "#000000", :null => false
      t.string  :color_link,                      :default => "#3B5998", :null => false
      t.string  :color_text_product,              :default => "#F77D00", :null => false
      t.string  :color_link_product,              :default => "#3B5998", :null => false
      t.integer  :products_per_page,              :default => 8,         :null => false
      t.integer :products_grid,                   :default => 4,         :null => false
      t.boolean :fan_access,                      :default => false,     :null => false
      t.boolean :search_engine,                   :default => false,     :null => false
      t.string  :logo
      t.string  :shutter
      t.string  :teaser
      t.timestamps
    end

    add_index :customizations, :shop_id, :unique => true

  end
end
