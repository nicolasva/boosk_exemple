class CreateZoneMembers < ActiveRecord::Migration
  def change
    create_table :zone_members do |t|
      t.references :zone
      t.string :code

      t.timestamps
    end

    add_index :zone_members, :zone_id
  end
end
