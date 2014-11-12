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

  def active_for_authentication?
    super and (!self.is_disabled or self.admin)
  end

  def name
    "#{user_name}"
  end

  def rank
    (Rank.find_by level: self.level).name
  end

  def add_one(x)
    x + 1
  end

  def wins
    self.update_attributes( :wins_count => add_one(self.wins_count),
                            :games_played_count => add_one(self.games_played_count),
                            :current_win_streak => add_one(self.current_win_streak) )
    if (self.current_win_streak > self.best_win_streak)
      self.update_attribute( :best_win_streak, self.current_win_streak )
    end
  end

  def loses
    self.update_attributes( :loss_count => add_one(self.loss_count),
                            :games_played_count => add_one(self.games_played_count),
                            :current_win_streak => 0 )
  end

  def ties
    self.update_attributes( :tie_count => add_one(self.tie_count),
                            :games_played_count => add_one(self.games_played_count) )
  end

  def reset_stats
    self.wins_count = 0
    self.loss_count = 0
    self.tie_count = 0
    self.current_win_streak = 0
    self.best_win_streak = 0
    self.games_played_count = 0
    self.coins = 0
    self.exp = 0
    self.level = 1
  end
end
