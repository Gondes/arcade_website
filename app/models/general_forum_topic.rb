class GeneralForumTopic < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates_length_of :title, :maximum => 24

  has_many :discussion_topics, :dependent => :destroy

  def discussion_topics_count
    temp = 'general_forum_topic_id = ' + self.id.to_s
    DiscussionTopic.where(temp).count
  end
end
