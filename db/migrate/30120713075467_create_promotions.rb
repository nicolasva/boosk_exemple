class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :description
      t.string :picture
      t.string :coupon_code
      t.boolean :free_shipping
      t.boolean :percent_discount
      t.float :discount_amount, :precision => 4, :scale => 2
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :shop
    end

    add_index :promotions, :shop_id

    create_table :promotion_rules do |t|
      t.references :promotion
      t.string :type
    end

    add_index :promotion_rules, :promotion_id

    create_table :promotion_rule_members do |t|
      t.references :promotion_rule
      t.references :item, :polymorphic => true
    end

    add_index :promotion_rule_members, :promotion_rule_id
    add_index :promotion_rule_members, [:item_id, :item_type]
  end
end
