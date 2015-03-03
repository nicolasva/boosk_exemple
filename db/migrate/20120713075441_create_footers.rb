class CreateFooters < ActiveRecord::Migration
  def change
    create_table :footers do |t|
      t.string :picture
      t.integer :offset, :default => 0
      t.references :customization
      t.timestamps
    end

    add_index :footers, :customization_id, :unique => true
  end
end
