class GeneralForumTopicsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :edit, :update]
  before_action :set_general_forum_topic, only: [:show, :edit, :update]

  def index
    @forum = GeneralForumTopic.all.sort_by(&:created_at)
  end

  def show
    @topics = @forum.discussion_topics.sort_by(&:created_at).reverse
  end

  def new
    @forum = GeneralForumTopic.new
  end

  def edit
    if !(current_user.has_forum_access?)
      redirect_to general_forum_topics_path, alert: 'You cannot edit this forum.'
    end
  end

  def update
    respond_to do |format|
      if @forum.update(general_forum_topic_params)
        format.html { redirect_to @forum, notice: 'General Forum Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @forum }
      else
        format.html { render :edit }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_general_forum_topic
      @forum = GeneralForumTopic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def general_forum_topic_params
      params.require(:general_forum_topic).permit(:title, :description, :forum_access_required)
    end
end
