class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    if @game.done
      @rounds = @game.rock_paper_scissor_rounds
    else
      redirect_to games_path
    end
  end

  # GET /games/new
  def new
    if ( valid_user(params[:user_1_id].to_i) or valid_user(params[:user_2_id].to_i) )# and (params[:user_1_id] != params[:user_2_id])
      @game = Game.new
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:user_1_id, :user_2_id, :winner_id, :done, :round_count,
                                   :user_1_win_count, :user_2_win_count, :tie_count, :name)
    end
end
