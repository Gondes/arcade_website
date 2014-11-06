class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_length_of :user_name, :maximum => 24
  validates_length_of :first_name, :maximum => 24
  validates_length_of :last_name, :maximum => 24
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :user_name, presence: true
  validates :user_name, uniqueness: { case_sensitive: false }

  has_attached_file :icon, :styles => { :medium => "300x300>", :small => "100x100>", :tiny => "16x16" }
  validates_attachment_size :icon, :less_than => 5.megabytes
  validates_attachment_content_type :icon, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  def name
    "#{user_name}"
  end

  def wins
    self.increment!(:wins_count)
    self.increment!(:games_played_count)
    self.increment!(:current_win_streak)
    if (self.current_win_streak > self.best_win_streak)
      self.update_attribute(:best_win_streak, self.current_win_streak)
    end
  end

  def loses
    self.increment!(:loss_count)
    self.increment!(:games_played_count)
    self.update_attribute(:current_win_streak, 0)
  end

  def ties
    self.increment!(:tie_count)
    self.increment!(:games_played_count)
  end

  def reset_stats
    self.wins_count = 0
    self.loss_count = 0
    self.tie_count = 0
    self.current_win_streak = 0
    self.best_win_streak = 0
    self.games_played_count = 0
  end
end
