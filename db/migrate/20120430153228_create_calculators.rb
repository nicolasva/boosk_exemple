class CreateCalculators < ActiveRecord::Migration
  def change
    create_table :calculators do |t|
      t.string :type
      t.references :shipping_method
      t.timestamps
    end

  end
end