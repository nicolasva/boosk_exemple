class CreateShopsUsers < ActiveRecord::Migration
  def up
    create_table :shops_users, :id => false do |t|
      t.integer :shop_id
      t.integer :user_id
    end
    remove_index :shops, :user_id
    remove_column :shops, :user_id
  end

  def down
    drop_table :shops_users
    add_index :shops, :user_id
    add_column :shops, :user_id
  end
end
