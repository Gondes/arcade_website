class AddAttachmentIconToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :icon
  end

  def self.down
    remove_attachment :users, :icon
  end
end
