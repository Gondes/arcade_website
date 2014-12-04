class GeneralForumTopic < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates_length_of :title, :maximum => 24

  has_many :discussion_topics, :dependent => :destroy

  def name
    self.title.split.map(&:capitalize).join(' ')
  end

  def discussion_topics_count
    temp = 'general_forum_topic_id = ' + self.id.to_s
    DiscussionTopic.where(temp).count
  end

  def show_description
    self.description
  end
end
