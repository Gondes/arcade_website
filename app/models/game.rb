class Game < ActiveRecord::Base
  after_initialize :init
  has_many :rounds, :dependent => :destroy
  accepts_nested_attributes_for :rounds

  attr_accessor :test_text

  def init
    self.user_1_win_count   ||= 0      #will set the default value only if it's nil
    self.user_2_win_count   ||= 0
    self.tie_count          ||= 0
    self.done               ||= false
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

  def best_of
    game_to * 2 - 1
  end

  def finished?
    self.best_of == self.user_1_win_count + self.user_2_win_count + self.tie_count
  end

  def try_to_generate_winner
    if self.finished?
      self.update_attribute(:done, true)
      var = self.user_1_win_count - self.user_2_win_count
      if var > 0
        self.update_attribute(:winner_id, user_1_id)
        self.player_1.wins
        self.player_2.loses
      elsif var < 0
        self.update_attribute(:winner_id, user_2_id)
        self.player_1.loses
        self.player_2.wins
      else
        self.update_attribute(:winner_id, 0)     #becuse user id will never be 0, 0 represents a tie
        self.player_1.ties
        self.player_2.ties
      end
    end
  end
end
