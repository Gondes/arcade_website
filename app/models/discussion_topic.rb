class DiscussionTopic < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates_length_of :title, :maximum => 64
  validates_length_of :description, :maximum => 2000

  has_many :comments, :dependent => :destroy
  belongs_to :general_forum_topic

  def original_poster
    User.find self.user_id
  end

  def closed_status
    if self.closed
      'Closed'
    else
      'Open'
    end
  end

  def comments_count
    temp = 'discussion_topic_id = ' + self.id.to_s
    Comment.where(temp).count
  end

  def is_op?(some_id)
    some_id == self.user_id
  end

  def exist?
    !self.title.nil? && !self.description.nil?
  end
end
