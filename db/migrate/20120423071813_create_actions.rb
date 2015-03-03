class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :type
      t.references :product
      t.references :user
    end

    add_index :actions, [:product_id, :type]
    add_index :actions, [:user_id, :type]
    
  end
end
