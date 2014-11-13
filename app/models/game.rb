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
      self.updated_at.strftime("%m-%d-%C_%H:%M")
    end
  end
  
  def finished?
    self.round_count == self.user_1_win_count + self.user_2_win_count + self.tie_count
  end

  def try_to_generate_winner
    if self.finished?
      var = self.user_1_win_count - self.user_2_win_count
      if var > 0
        self.update_attributes( :done => true, :winner_id => user_1_id )
        self.player_1.wins
        self.player_2.loses
      elsif var < 0
        self.update_attributes( :done => true, :winner_id => user_2_id )
        self.player_1.loses
        self.player_2.wins
      else
        self.update_attribute( :done, true )
        self.player_1.ties
        self.player_2.ties
      end
    end
  end
end
