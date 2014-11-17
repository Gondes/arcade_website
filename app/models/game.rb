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

  def winner
    unless winner_id.nil?
      User.find winner_id
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
      ""
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
      player_1_level = self.player_1.level
      player_2_level = self.player_2.level
      if var > 0
        self.update_attributes( :done => true, :winner_id => user_1_id )
        self.player_1.wins_against(player_2_level)
        self.player_2.loses_against(player_1_level)
      elsif var < 0
        self.update_attributes( :done => true, :winner_id => user_2_id )
        self.player_1.loses_against(player_2_level)
        self.player_2.wins_against(player_1_level)
      else
        self.update_attribute( :done, true )
        self.player_1.ties_against(player_2_level)
        self.player_2.ties_against(player_1_level)
      end
    end
  end
end
