class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer    :quantity,                                       :null => false
      t.decimal    :price,            :precision => 8, :scale => 2, :null => false

      t.references :product_variant
      t.references :order

      t.timestamps
    end

    add_index :line_items, :product_variant_id
    add_index :line_items, :order_id
  end
end
