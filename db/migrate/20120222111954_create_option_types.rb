class CreateOptionTypes < ActiveRecord::Migration
  def change
    create_table :option_types do |t|
      t.string     :name,                       :null => false
      t.string     :value,                      :null => false

      t.timestamps

      t.references :shop
    end

    add_index :option_types, :shop_id
  end
end
