class CreateDiscusionTopics < ActiveRecord::Migration
  def change
    create_table :discusion_topics do |t|
      t.string :title
      t.text :description
      t.integer :general_forum_topic_id
      t.integer :user_id
      t.boolean :closed, :default => false
      t.boolean :removed, :default => false

      t.timestamps
    end
  end
end
