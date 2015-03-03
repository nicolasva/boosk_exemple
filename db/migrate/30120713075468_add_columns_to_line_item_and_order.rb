class AddColumnsToLineItemAndOrder < ActiveRecord::Migration
  def change
    change_table :orders do |o|
      o.decimal :shipment, :precision => 8, :scale => 2, :null => false
    end

    change_table :line_items do |l|
      l.string :name
      l.string :sku
      l.string :uuid
      l.decimal :tax, :precision => 8, :scale => 2, :null => false
      l.decimal :price_ht, :precision => 8, :scale => 2, :null => false

      l.remove :product_variant_id

      l.rename :price, :price_ttc
    end
  end
end
