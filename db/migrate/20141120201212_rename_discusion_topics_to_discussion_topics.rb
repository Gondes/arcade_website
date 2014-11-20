class RenameDiscusionTopicsToDiscussionTopics < ActiveRecord::Migration
  def change
  	rename_table :discusion_topics, :discussion_topics
  end
end
