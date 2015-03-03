class CreateProductVariantPictures < ActiveRecord::Migration
  def change
    create_table :product_variant_pictures do |t|
      t.string  :picture
      t.string  :cached_path
      t.boolean :is_master,   :default => false
      
      t.timestamps

      t.references :product_variant
    end

    add_index :product_variant_pictures, :product_variant_id
  end
end
