class CreateProductVariants < ActiveRecord::Migration
  def change
    create_table :product_variants do |t|
      t.string    :sku,         :default => "",               :null => false
      t.decimal   :price,       :precision => 8, :scale => 2, :null => false
      t.integer   :quantity,                                  :null => false
      t.decimal   :weight,      :precision => 8, :scale => 2
      t.decimal   :height,      :precision => 8, :scale => 2
      t.decimal   :width,       :precision => 8, :scale => 2
      t.decimal   :depth,       :precision => 8, :scale => 2
      t.datetime  :deleted_at
      t.boolean   :is_master,   :default => false

      t.timestamps

      t.references :product
    end

    add_index :product_variants, :sku
    add_index :product_variants, :product_id
  end
end
