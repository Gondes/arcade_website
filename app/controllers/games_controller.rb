class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :update, :destroy, :accept, :reject]

  # GET /games
  # GET /games.json
  def index
    amount = 25
    if !(params[:user_id].nil?)
      @games = Game.where("user_1_id = ? OR user_2_id = ?", params[:user_id], params[:user_id])
      @games = @games.order(updated_at: :desc)
      
      if !(params[:page].nil?) && (params[:page].to_i > 0)
        @last_page = (@games.count - 1) / amount + 1
        @next_available = (( @games.limit(amount).offset((amount) * (params[:page].to_i)) ).size > 0)
        @previous_available = params[:page].to_i > 1
        @games = @games.limit(amount).offset(amount * (params[:page].to_i - 1))
      else
        redirect_to games_url(:user_id => params[:user_id].to_i, :page => 1)
      end
    else
      redirect_to games_url(:user_id => current_user.id)
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    if @game.done
      @rounds = @game.rock_paper_scissor_rounds.sort_by(&:round_number)
    else
      redirect_to games_path
    end
  end

  # GET /games/new
  def new
    if ( valid_user(params[:user_1_id].to_i) or valid_user(params[:user_2_id].to_i) )
      @game = Game.new
      @challenger = User.find(params[:user_1_id])
      @challenged = User.find(params[:user_2_id])
    else
      redirect_to games_path
    end
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        @game.user_1_level = @game.player_1.level
        @game.user_2_level = @game.player_2.level
        @game.fee = @game.calculate_challenge_fee
        @game.save
        challenger = User.find(@game.player_1.id)
        if challenger.coins >= @game.fee
          challenger.remove_coins(@game.fee)
          challenger.save

          #This needs a major change in logic to accomidate other game types
          if @game.name == "rock_paper_scissor"
            (0..@game.round_count - 1).each do |i|
              #Round.create!(:game_id => @game.id)
              rock_paper_scissor_round = RockPaperScissorRound.new
              rock_paper_scissor_round.game = @game
              rock_paper_scissor_round.round_number = i + 1
              rock_paper_scissor_round.save!
            end
          end
          format.html { redirect_to games_url, notice: 'Game was successfully created.' }
          format.json { render :index, status: :created, location: @game }
        else
          @game.destroy
          format.html { redirect_to users_url, alert: 'You cannot pay the challenge fee.' }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to games_url }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { redirect_to @game }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def accept
    @game.accepted = true
    respond_to do |format|
      if @game.save
        challenged = User.find(@game.player_2.id)
        challenged.add_coins(@game.fee)
        challenged.save
        format.html { redirect_to rock_paper_scissor_rounds_path(game_id: @game.id),
                      notice: 'Challenge was accepted.' }
      end
    end
  end

  def reject
    challenged = User.find(@game.player_1.id)
    challenged.add_coins(@game.fee)
    challenged.save

    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Challenge was rejected.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:user_1_id, :user_2_id, :winner_id, :done, :round_count,
                                   :user_1_win_count, :user_2_win_count, :tie_count, :name,
                                   :accepted)
    end
end
