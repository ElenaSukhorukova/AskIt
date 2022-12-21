# frozen_string_literal: true

class EditUsers < ActiveRecord::Migration[7.0]
  reversible do |dir|
    change_table :users do |t|
      dir.up do
        t.column :encrypted_password, :string
        t.column :reset_password_token, :string
        t.column :reset_password_sent_at, :datetime
        t.column :remember_created_at, :datetime
        t.string :password_digest
      end

      dir.down do
        t.remove :encrypted_password
        t.remove :reset_password_token
        t.remove :reset_password_sent_at
        t.remove :remember_created_at
      end
    end
  end
end
