class Game < ActiveRecord::Base
  has_many :rounds, :dependent => :destroy
  accepts_nested_attributes_for :rounds

  attr_accessor :test_text

  def player_1
    User.find user_1_id
  end

  def player_2
    User.find user_2_id
  end

  def best_of
    game_to * 2 - 1
  end

  def generate_win_chart
    @win_table = [["Chart", "Rock", "Paper", "Scissors", "Nothing"], ["Rock", 0, -1, 1, 1], ["Paper", 1, 0, -1, 1], ["Scissors", -1, 1, 0, 1], ["Nothing", -1, -1, -1, 0]]
  end

  def get_result(p1, p2)
    @win_table[p1][p2]
  end
end
