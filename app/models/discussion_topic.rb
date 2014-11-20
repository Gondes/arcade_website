class DiscussionTopic < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates_length_of :title, :maximum => 64

  has_many :comments, :dependent => :destroy
  belongs_to :general_forum_topic

  def op
    User.find self.user_id
  end

  def comments_count
    temp = 'discussion_topic_id = ' + self.id.to_s
    Comment.where(temp).count
  end
end
