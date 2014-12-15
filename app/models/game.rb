class Game < ActiveRecord::Base
  validates :user_1_id, presence: true
  validates :user_2_id, presence: true
  validate :player_1_and_2_are_different
  has_many :rock_paper_scissor_rounds, :dependent => :destroy
  accepts_nested_attributes_for :rock_paper_scissor_rounds

  def player_1_and_2_are_different
    if self.user_1_id == self.user_2_id
      errors.add(:base, 'Player 1 must be different from Player 2')
    end
  end

  def player_1
    User.find user_1_id
  end

  def player_2
    User.find user_2_id
  end

  def static_player_1
    if self.user_1_level != 0
      rank = Rank.find_by(:level => self.user_1_level)
      rank.name + "-" + self.user_1_level.to_s + " " + player_1.name
    else
      "Lvl-" + self.user_1_level.to_s + " " + player_1.name
    end
  end

  def static_player_2
    if self.user_2_level != 0
      rank = Rank.find_by(:level => self.user_2_level)
      rank.name + "-" + self.user_2_level.to_s + " " + player_2.name
    else
      "Lvl-" + self.user_2_level.to_s + " " + player_2.name
    end
  end

  def show_player_1_exp
    if self.user_1_exp_change >= 0
      "gained " + self.user_1_exp_change.to_s + " exp"
    else
      "lost " + (self.user_1_exp_change * -1).to_s + " exp"
    end
  end

  def show_player_2_exp
    if self.user_2_exp_change >= 0
      "gained " + self.user_2_exp_change.to_s + " exp"
    else
      "lost " + (self.user_2_exp_change * -1).to_s + " exp"
    end
  end

  def winner
    #unless winner_id.nil?
    #  User.find winner_id
    #end

    if self.finished?
      if (self.user_1_win_count > self.round_count - self.tie_count - self.user_1_win_count)
        self.player_1
      elsif (self.user_2_win_count > self.round_count - self.tie_count - self.user_2_win_count)
        self.player_2
      else
        'tie'
      end
    end
  end

  def winner_status
    temp = self.winner
    if temp == nil
      
    elsif temp == 'tie'
      'Tie!'
    else
      temp.name
    end
  end

  def winner_declaration
    temp = self.winner
    if temp == nil
      
    elsif temp == 'tie'
      "It's a Tie!"
    else
      temp.name + " wins this game!"
    end
  end

  def clean_name
    var = name.gsub!('_',' ')
    var.split.map(&:capitalize).join(' ')
  end

  def end_date
    if self.done
      self.updated_at.strftime("%B %d, %Y, %H:%M %Z")
    else
      "In Progress"
    end
  end
  
  def finished?
    ( (self.round_count == self.user_1_win_count + self.user_2_win_count + self.tie_count) or 
      (self.user_1_win_count > self.round_count - self.tie_count - self.user_1_win_count) or
      (self.user_2_win_count > self.round_count - self.tie_count - self.user_2_win_count) )
  end

  def try_to_generate_winner
    if self.finished?
      var = self.user_1_win_count - self.user_2_win_count
      player_1_change = 0
      player_2_change = 0
      if var > 0
        self.update_attributes( :done => true, :winner_id => user_1_id )
        player_1_change = self.player_1.wins_against(self.user_2_level)
        player_2_change = self.player_2.loses_against(self.user_1_level)
      elsif var < 0
        self.update_attributes( :done => true, :winner_id => user_2_id )
        player_1_change = self.player_1.loses_against(self.user_2_level)
        player_2_change = self.player_2.wins_against(self.user_1_level)
      else
        self.update_attribute( :done, true )
        player_1_change = self.player_1.ties_against(self.user_2_level)
        player_2_change = self.player_2.ties_against(self.user_1_level)
      end
      self.update_game_stats(player_1_change, player_2_change)
    end
  end

  def update_game_stats(player_1_change, player_2_change)
    if player_1_change > 0
      self.update_attribute( :user_1_coins_earned, player_1_change )
    end
    if player_2_change > 0
      self.update_attribute( :user_2_coins_earned, player_2_change )
    end
    self.update_attributes( :user_1_exp_change => player_1_change,
                            :user_2_exp_change => player_2_change )
  end

  def calculate_challenge_fee
    challenge_fee = (self.player_2.level - self.player_1.level) * 10
    if challenge_fee < 0
      0
    else
      challenge_fee
    end
  end

  def calculate_challenge_fee_from(challenger_level, challenged_level)
    challenge_fee = (challenged_level - challenger_level) * 10
    if challenge_fee < 0
      0
    else
      challenge_fee
    end
  end
end
