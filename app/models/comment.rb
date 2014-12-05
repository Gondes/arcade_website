class Comment < ActiveRecord::Base
  validates :content, presence: true
  validates_length_of :content, :maximum => 2000

  belongs_to :discussion_topic

  def commenter
    User.find self.user_id
  end

  def forum
    GeneralForumTopic.find self.discussion_topic.general_forum_topic
  end

  def show_content
    if !self.removed
      self.content
    else
      "---This comment has been removed---"
    end
  end
end
