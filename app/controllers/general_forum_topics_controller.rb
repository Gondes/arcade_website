class GeneralForumTopicsController < ApplicationController
  before_action :set_general_forum_topic, only: [:show, :edit, :update, :destroy]

  def index
    @forum = GeneralForumTopic.all
  end

  def show
    @topics = @forum.discussion_topics.sort_by(&:created_at).reverse
  end

  def new
    @forum = GeneralForumTopic.new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
    def set_general_forum_topic
      @forum = GeneralForumTopic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def general_forum_topic_params
      params.require(:general_forum_topic).permit(:title, :description)
    end
end
