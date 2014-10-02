class Round < ActiveRecord::Base
	belongs_to :game

	#def moves
	@moves = ["Rock", "Paper", "Scissors"]
	#end

	def game
		Game.find game_id
	end

	def player_1
		User.find user_1_id
	end

	def player_2
		User.find user_2_id
	end
end
