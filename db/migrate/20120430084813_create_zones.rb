class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :name, :null => :false
      t.references :shop
      t.timestamps
    end

    add_index :zones, :shop_id
  end

end
