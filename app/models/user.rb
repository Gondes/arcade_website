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
    super and (!self.is_disabled or self.admin? or self.master_admin?)
  end

  def name
    "#{user_name}"
  end

  def admin?
    self.admin
  end

  def master_admin?
    self.master_admin
  end

  def is_hidden?
    self.is_hidden
  end

  def is_disabled?
    self.is_disabled
  end

  def has_forum_access?
    self.forum_access or self.master_admin?
  end

  def has_user_access?
    self.has_user_stat_access? or self.has_user_profile_access? or self.has_give_user_access?
  end

  def has_user_stat_access?
    self.user_stat_access or self.master_admin?
  end

  def has_user_profile_access?
    self.user_profile_access or self.master_admin?
  end

  def has_game_access?
    self.game_access or self.master_admin?
  end

  def has_give_user_access?
    self.give_access or self.master_admin?
  end

  def list_access_rights
    temp = ""
    self.admin? ? temp += "Admin" : false
    self.has_forum_access? ? temp += ", Forum Access" : false
    self.has_user_stat_access? ? temp += ", User Stat Access" : false
    self.has_user_profile_access? ? temp += ", User Profile Access" : false
    self.has_game_access? ? temp += ", Game Access" : false
    self.has_give_user_access? ? temp += ", Give Access" : false
    self.master_admin ? temp += ", Master Admin" : false
    if temp.length == 0
      "None"
    else
      temp
    end
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

  #def level_up
  #  self.level += 1
  #end

  #def level_down
  #  self.level -= 1
  #end

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

  # This method returns int > 0 representing the exp gained for the game to record
  def wins_against(opponent_level)
    update_stats_wins
    exp_gained = self.calculate_win_exp_against(opponent_level)
    self.update_attributes( :exp => self.exp + exp_gained,
                            :coins => self.coins + exp_gained )
    self.update_rank
    return exp_gained
  end

  # This method returns int < 0 representing the exp lost for the game to record
  def loses_against(opponent_level)
    update_stats_loses
    exp_lost = self.calculate_lose_exp_against(opponent_level)
    if ( (check = (self.exp - exp_lost)) <= 0 )
      exp_lost = self.exp
      self.update_attribute( :exp, 0 )
    else
      self.update_attribute( :exp, check )
    end
    self.update_rank
    return exp_lost * -1
  end

  # Returns positive or negative int depending if user gained or loss exp
  def ties_against(opponent_level)
    update_stats_ties
    exp_change = self.calculate_tie_exp_against(opponent_level)
    self.update_attribute( :exp, self.exp + exp_change )
    self.update_rank
    return exp_change
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

  # Returns a positive integer > 0 that represents exp lost
  def calculate_lose_exp_against(opponent_level)
    base_exp = self.level
    level_difference_exp = opponent_level - self.level

    if ((base_exp = base_exp - level_difference_exp) < 1)
      return 5
    else
      return base_exp * 10
    end
  end

  # Returns positive if you are lower leveled and negative if you are higher leveled
  def calculate_tie_exp_against(opponent_level)
    level_difference_exp = opponent_level - self.level
    return level_difference_exp * 5
  end

  def remove_coins(amount)
    self.coins -= amount
    if self.coins < 0
      self.coins = 0
    end
  end

  def add_coins(amount)
    self.coins += amount
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
