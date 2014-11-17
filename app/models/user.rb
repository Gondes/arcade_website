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
    Rank.find_by(:level => self.level)
  end

  def show_rank
    self.level.to_s + "-" + (Rank.find_by level: self.level).name
  end

  def next_rank
    if self.level < Rank.maximum("level")
      Rank.find_by(:level => (self.level + 1))
    else
      self.rank
    end
  end

  def previous_rank
    if self.level > Rank.minimum("level")
      Rank.find_by(:level => (self.level - 1))
    else
      self.rank
    end
  end

  def rank_up
    self.update_attribute( :level, self.next_rank.level )
  end

  def rank_down
    self.update_attribute( :level, self.previous_rank.level )
  end

  def update_rank
    if self.exp < self.rank.exp_required
      self.rank_down
    elsif self.exp >= next_rank.exp_required
      self.rank_up
    end
  end

  def update_stats_wins
    self.update_attributes( :wins_count => (self.wins_count + 1),
                            :games_played_count => (self.games_played_count + 1),
                            :current_win_streak => (self.current_win_streak + 1) )
    if (self.current_win_streak > self.best_win_streak)
      self.update_attribute( :best_win_streak, self.current_win_streak )
    end
  end

  def update_stats_loses
    self.update_attributes( :loss_count => (self.loss_count + 1),
                            :games_played_count => (self.games_played_count + 1),
                            :current_win_streak => 0 )
  end

  def update_stats_ties
    self.update_attributes( :tie_count => (self.tie_count + 1),
                            :games_played_count => (self.games_played_count + 1) )
  end

  def wins_against(opponent_level)
    update_stats_wins
    exp_gained = self.calculate_win_exp_against(opponent_level)
    self.update_attributes( :exp => self.exp + exp_gained,
                            :coins => self.coins + exp_gained )
    self.update_rank
  end

  def loses_against(opponent_level)
    update_stats_loses
    if ( (check = (self.exp - self.calculate_lose_exp_against(opponent_level))) <= 0 )
      self.update_attribute( :exp, 0 )
    else
      self.update_attribute( :exp, check )
    end
    self.update_rank
  end

  def ties_against(opponent_level)
    update_stats_ties
    self.update_attribute( :exp, self.exp + self.calculate_tie_exp_against(opponent_level) )
    self.update_rank
  end

  def calculate_win_exp_against(opponent_level)
    base_exp = self.level
    level_difference_exp = opponent_level - self.level
    win_streak_multiplier = 1
    if current_win_streak == 2
      win_streak_multiplier = 1.5
    elsif current_win_streak > 2
      win_streak_multiplier = 2
    end

    return (base_exp + level_difference_exp) * 10 * win_streak_multiplier
  end

  def calculate_lose_exp_against(opponent_level)
    base_exp = self.level
    level_difference_exp = opponent_level - self.level

    if ((base_exp = base_exp - level_difference_exp) < 1)
      return 5
    else
      return base_exp * 10
    end
  end

  def calculate_tie_exp_against(opponent_level)
    level_difference_exp = opponent_level - self.level
    return level_difference_exp * 5
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
