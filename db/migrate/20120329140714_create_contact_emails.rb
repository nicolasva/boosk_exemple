class CreateContactEmails < ActiveRecord::Migration
  def change
    create_table :contact_emails do |t|
      t.string     :email,                       :null => false

      t.references :contact
      t.timestamps
    end

    add_index :contact_emails, :contact_id
  end
end
