class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  def start
    @game = Game.find params[:id]
  end

  def play
    @game = Game.find params[:game_id]
    @round = Round.find params[:round_id]
  end

  # GET /games/new
  def new
    @game = Game.new
    #3.times { @game.rounds.build }
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save

        (0..@game.best_of - 1).each do |i|
          #Round.create!(:game_id => @game.id)
          round = Round.new
          round.game = @game
          round.user_1_id = @game.user_1_id
          round.user_2_id = @game.user_2_id
          round.round_number = i + 1
          round.save!
        end

        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update

    Rails.logger.info '*' * 200

    respond_to do |format|
      Rails.logger.info game_params.inspect
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
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
      params.require(:game).permit(:user_1_id, :user_2_id, :winner_id, :done, :game_to)
    end
end
