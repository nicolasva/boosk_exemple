class AddFunelTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :funel_type, :integer, :default => 1
    add_column :users, :unsuscribe, :boolean, :default => false
  end
end
