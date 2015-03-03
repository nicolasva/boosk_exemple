class CreateShippingMethods < ActiveRecord::Migration
  def change
    create_table :shipping_methods do |t|
      t.string :name
      t.boolean :match_all, :default => false
      t.boolean :match_one, :default => false
      t.boolean :match_none, :default => false
      t.references :shop
      t.references :zone
      t.references :shipping_category
      t.timestamps
    end

    add_index :shipping_methods, :shop_id
  end
end