class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string  :name,                                     :null => false
      t.decimal :monthly_price,                            :null => false
      t.decimal :yearly_price,                             :null => false

      t.integer :number_admin,          :default => 1,     :null => false
      t.integer :number_f_shop,         :default => 1,     :null => false
      t.integer :number_m_shop,         :default => 1,     :null => false
      t.integer :number_w_shop,         :default => 1,     :null => false
      t.integer :number_product,        :default => 200,   :null => false

      t.boolean :has_google_shopping,   :default => false, :null => false
      t.boolean :has_social,            :default => false, :null => false
      t.boolean :has_feature_product,   :default => false, :null => false
      t.boolean :has_deals,             :default => false, :null => false
      t.boolean :has_data_import,       :default => false, :null => false
      t.integer :has_auto_data_import,  :default => 24
      t.boolean :has_customization,     :default => false, :null => false
      t.boolean :has_analytics,         :default => false, :null => false
      t.boolean :has_api_access,        :default => false, :null => false
    end
  end
end
