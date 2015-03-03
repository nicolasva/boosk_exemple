class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :name
      t.string :key
      t.string :value_type
      t.text :value

      t.timestamps
    end
  end
end
