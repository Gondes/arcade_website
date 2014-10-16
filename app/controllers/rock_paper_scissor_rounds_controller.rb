class RockPaperScissorRoundsController < ApplicationController
  before_action :set_round, only: [:show, :edit, :update, :destroy]

  # GET /rounds
  # GET /rounds.json
  def index
    if params.has_key? :game_id
      @game = Game.find params[:game_id]
      @rounds = @game.rock_paper_scissor_rounds
    else
      @rounds = RockPaperScissorRound.all
    end
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
  end

  # GET /rounds/new
  def new
    @round = RockPaperScissorRound.new
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
        format.html { redirect_to @round, notice: 'RockPaperScissorRound was successfully created.' }
        format.json { render :show, status: :created, location: @round }
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
      if @round.unplayed?
        if @round.update(rock_paper_scissor_round_params)
          format.html { redirect_to @round, notice: 'Round was successfully updated.' }
          format.json { render :show, status: :ok, location: @round }

          @round.find_winner

          if @round.save!
            format.html { redirect_to @round, notice: 'Round and Game were successfully updated.' }
            format.json { render :show, status: :ok, location: @round }
          else
            format.html { render :edit }
            format.json { render json: @round.errors, status: :unprocessable_entity }
          end
        else
          format.html { render :edit }
          format.json { render json: @round.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
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
