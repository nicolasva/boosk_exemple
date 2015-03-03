class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string     :uuid,       :limit => 36,   :null => false
      t.string     :slug,                       :null => false
      t.string     :name,                       :null => false
      t.text       :description
      t.string     :permalink

      t.boolean    :status,     :default => true
      t.boolean    :highlight,  :default => false

      t.datetime    :available_on
      t.datetime    :deleted_at
      t.timestamps

      t.references :shop
      t.references :tax_rate
      t.references :shipping_method
    end
    
    add_index :products, :uuid
    add_index :products, :shop_id
    add_index :products, :tax_rate_id
    add_index :products, :shipping_method_id
  end
end
