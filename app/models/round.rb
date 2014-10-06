class Round < ActiveRecord::Base
	belongs_to :game

  WIN_MATRIX =  [
                  ["Chart", "Rock", "Paper", "Scissor", "Nothing"],
                  ["Rock", 0, -1, 1, 1],
                  ["Paper", 1, 0, -1, 1],
                  ["Scissor", -1, 1, 0, 1],
                  ["Nothing", -1, -1, -1, 0]
                ]
  
	def game
		Game.find game_id
	end


  def winner
    unless winner_id.nil?
      User.find winner_id
    end
  end

  def unplayed?
    user_1_move.nil? and user_2_move.nil?
  end

	def get_move_value(move)
		case move.downcase
    when "rock"
		  1
		when "paper"
		  2
		when "scissor"
			3
    else
      0
		end
	end

  def user_1_move_id
    get_move_value(user_1_move)
  end

  def user_2_move_id
    get_move_value(user_2_move)
  end  

  def find_winner
    case WIN_MATRIX[user_1_move_id][user_2_move_id]
    when 0
      self.tie = 1
      self.game.increment!(:tie_count)
    when 1
      self.tie = 0
      self.winner_id = game.user_1_id
      self.game.increment!(:user_1_win_count)
    else
      self.tie = 0
      self.winner_id = game.user_2_id
      self.game.increment!(:user_2_win_count)
    end
    self.game.try_to_generate_winner
  end
end
