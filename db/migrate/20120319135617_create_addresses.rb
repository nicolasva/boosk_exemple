class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string   :designation
      t.string   :addr
      t.string   :zip_code
      t.string   :country
      t.string   :state
      t.string   :city
      
      t.timestamps
      t.references :addressable, :polymorphic => true
    end

  end
end
