class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :plan
      t.string :alias
      t.date :starting_on
      t.date :ending_on
    end

    add_index :subscriptions, :user_id, :unique => true
  end
end
