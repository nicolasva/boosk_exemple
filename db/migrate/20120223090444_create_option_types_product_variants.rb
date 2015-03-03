class CreateOptionTypesProductVariants < ActiveRecord::Migration
  def up
    create_table :option_types_product_variants, :id => false do |t|
      t.integer :option_type_id
      t.integer :product_variant_id
    end
  end
  
  def down
    drop_table :option_types_product_variants
  end
end
