class MoreAuthentication < ActiveRecord::Migration
  def change
    add_column :general_forum_topics, :forum_access_required, :boolean, :default => false

    add_column :users, :forum_access, :boolean, :default => false
    add_column :users, :user_stat_access, :boolean, :default => false
    add_column :users, :user_profile_access, :boolean, :default => false
    add_column :users, :game_access, :boolean, :default => false
    add_column :users, :give_access, :boolean, :default => false
    add_column :users, :master_admin, :boolean, :default => false
  end
end
