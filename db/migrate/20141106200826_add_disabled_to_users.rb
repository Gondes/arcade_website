class AddDisabledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_disabled, :boolean, :default => false
    add_column :users, :is_hidden, :boolean, :default => false
  end
end
