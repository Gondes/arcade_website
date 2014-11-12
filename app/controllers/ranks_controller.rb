class RanksController < ApplicationController
  
  def index
  	@ranks = Rank.all
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rank
      @rank = Rank.find(params[:id])
    end
end
