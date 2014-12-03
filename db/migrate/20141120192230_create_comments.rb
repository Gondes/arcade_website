class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

      t.text :content
      t.integer :discussion_topic_id
      t.integer :user_id
      
      t.boolean :removed, :default => false

      t.timestamps
    end
  end
end
