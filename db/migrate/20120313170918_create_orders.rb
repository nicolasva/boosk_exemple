class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string   :number,               :limit => 15
      t.decimal  :item_total,           :default => 0.0, :null => false
      t.decimal  :total,                :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.datetime :completed_at
      t.decimal  :credit_total,         :default => 0.0
      t.decimal  :payment_total,        :precision => 8, :scale => 2, :default => 0.0
      t.string   :payment_state
      t.string   :email
      t.string   :workflow_state
      t.text     :special_instructions

      t.timestamps
      t.references :shop
    end
    
    add_index :orders, :shop_id
  end
end
