class RanksController < ApplicationController
  before_action :set_rank, only: [:show, :edit, :update]

  def index
    #Rank.order(':created_at DESC')
    @ranks = Rank.all
    @ranks = @ranks.sort_by(&:level)
    #@ranks.order(:created_at)
  end

  #def show
  #end

  #def new
  #  @rank = Rank.new
  #end

  def edit
    if !(user_admin?)
      redirect_to ranks_path
    end
  end

  #def create
  #end

  def update
    respond_to do |format|
      if @rank.update(rank_params)
        format.html { redirect_to ranks_path, notice: 'Rank was successfully updated.' }
        format.json { render :show, status: :ok, location: ranks_path }
      else
        format.html { render :edit }
        format.json { render json: @faq.errors, status: :unprocessable_entity }
      end
    end
  end

  #def destroy
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rank
      @rank = Rank.find(params[:id])
    end

    def rank_params
      params.require(:rank).permit(:level, :name, :exp_required)
    end
end
