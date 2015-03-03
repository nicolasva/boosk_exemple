class UpdateOrders < ActiveRecord::Migration
  def change
    change_column :orders, :number, :string
    change_column :orders, :total, :decimal, :precision => 8, :scale => 2, :default => 0.0, :null => false
  end
end
