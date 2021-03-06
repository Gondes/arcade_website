class RockPaperScissorRoundsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_player
  before_action :set_round, only: [:show, :edit, :update, :destroy]

  def authenticate_player
    if params[:game_id].nil?
      @round = RockPaperScissorRound.find params[:id]
      @game = Game.find @round.game_id
    else
      @game = Game.find params[:game_id]
    end
    if (@game.player_1.id != current_user.id and @game.player_2.id != current_user.id and !current_user.has_game_access?)
      redirect_to games_url
    end
  end

  # GET /rounds
  # GET /rounds.json
  def index
    if params.has_key? :game_id
      @game = Game.find params[:game_id]
      @rounds = @game.rock_paper_scissor_rounds
      @rounds = @rounds.sort_by(&:round_number)
    else
      @rounds = RockPaperScissorRound.all
    end

    if @game.done
      redirect_to game_path(@game)
    end
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
  end

  # GET /rounds/1/edit
  def edit
  end

  # POST /rounds
  # POST /rounds.json
  def create
    @round = RockPaperScissorRound.new(rock_paper_scissor_round_params)

    respond_to do |format|
      if @round.save
        format.html { redirect_to rock_paper_scissor_rounds_url, notice: 'RockPaperScissorRound was successfully created.' }
        format.json { render :index, status: :created, location: @round }
      else
        format.html { render :new }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rounds/1
  # PATCH/PUT /rounds/1.json
  def update
    respond_to do |format|
      if !(@round.finished?) and @round.update(rock_paper_scissor_round_params) and @round.save!
        if @round.finished?
          @round.find_winner
          if @round.save!
            @round.game.save!
            @round.game.player_1.save!
            @round.game.player_2.save!
            
            format.html { redirect_to @round, notice: 'This round has finished.' }
            format.json { render :show, status: :ok, location: @round }
          # If you can make this statement fail, I would be very surprised
          #else
          #  format.html { render :edit, notice: 'Error 2.' }
          #  format.json { render json: @round.errors, status: :unprocessable_entity }
          end
        else
          format.html { redirect_to @round, notice: 'You have selected your move.' }
          format.json { render :show, status: :ok, location: @round }
        end
      else
        format.html { render :edit, notice: 'Error 1.' }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rounds/1
  # DELETE /rounds/1.json
  def destroy
    @round.destroy
    respond_to do |format|
      format.html { redirect_to rock_paper_scissor_rounds_url, notice: 'RockPaperScissorRound was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_round
      @round = RockPaperScissorRound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rock_paper_scissor_round_params
      params.require(:rock_paper_scissor_round).permit(:game_id, :user_1_move, :user_2_move,
                                    :winner_id, :tie, :round_number)
    end
end
