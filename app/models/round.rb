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

  def played?
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
    when 1
      self.tie = 0
      self.winner_id = self.user_1_id
    else
      self.tie = 0
      self.winner_id = self.user_2_id
    end
  end
end
