class CreateTaxRates < ActiveRecord::Migration
  def change
    create_table :tax_rates do |t|
      t.string     :label, :null => false
      t.decimal    :rate, :precision => 6, :scale => 2, :null => false
      t.references :shop
      t.timestamps
    end

    create_table :tax_rates_zones, :id => false do |t|
      t.references :tax_rate
      t.references :zone
    end

    add_index :tax_rates, :shop_id
    add_index :tax_rates_zones, :zone_id
    add_index :tax_rates_zones, :tax_rate_id
  end
end
