class AddMenuColorsToCustomizations < ActiveRecord::Migration
  def change
    add_column :customizations, :color_text_menu, :string, :default => "#FFFFFF", :null => false
    add_column :customizations, :color_text_menu_hover, :string, :default => "#F77D00", :null => false
  end
end
