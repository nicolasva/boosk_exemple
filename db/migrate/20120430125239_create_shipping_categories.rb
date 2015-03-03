class CreateShippingCategories < ActiveRecord::Migration
  def change
    create_table :shipping_categories do |t|
      t.string :name
      t.references :shop
      t.timestamps
    end

    add_index :shipping_categories, :shop_id

    add_column :products, :shipping_category_id, :integer

  end
end
