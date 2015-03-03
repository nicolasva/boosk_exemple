class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table :taxonomies do |t|
      t.string :name
      t.references :shop

      t.timestamps
    end

    add_index :taxonomies, :shop_id
  end
end
