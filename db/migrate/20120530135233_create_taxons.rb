class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      t.string :name
      t.references :taxonomy
      t.integer :parent_id
      t.integer :rgt
      t.integer :lft
      t.integer :position

      t.timestamps
    end

    add_index :taxons, :parent_id
    add_index :taxons, :taxonomy_id

    create_table :products_taxons, :id => false do |t|
      t.references :product
      t.references :taxon
    end

    add_index :products_taxons, :product_id
    add_index :products_taxons, :taxon_id
  end
end
