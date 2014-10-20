class ChangingUserIntoDevise < ActiveRecord::Migration
  def change
  	drop_table :accounts

    add_column :users, :email, :string, default: "", null: false, unique: true
    add_column :users, :encrypted_password, :string, default: "", null: false
    add_column :users, :reset_password_token, :string, unique: true
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_created_at, :datetime
    add_column :users, :sign_in_count, :integer, default: 0,  null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :inet
    add_column :users, :last_sign_in_ip, :inet

    remove_column :users, :account_id
  end
end
