class Comment < ActiveRecord::Base
  validates :content, presence: true

  belongs_to :discussion_topic

  def commenter
    User.find self.user_id
  end
end
