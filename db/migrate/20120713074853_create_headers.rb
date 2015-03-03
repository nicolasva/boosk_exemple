class CreateHeaders < ActiveRecord::Migration
  def change
    create_table :headers do |t|
      t.string :picture
      t.integer :offset, :default => 0
      t.references :customization
      t.timestamps
    end

    add_index :headers, :customization_id, :unique => true
  end
end