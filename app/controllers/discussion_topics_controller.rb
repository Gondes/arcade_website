class DiscussionTopicsController < ApplicationController
  before_action :set_discussion_topic, only: [:show, :edit, :update, :destroy]

  def index
    @forum = DiscussionTopic.all
  end

  def show
    @topics = @forum.comments.sort_by(&:created_at).reverse
  end

  def new
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
    def set_discussion_topic
      @topic = DiscussionTopic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_topic_params
      params.require(:discussion_topic).permit(:title, :description, :user_id,
        :closed, :removed, :general_forum_topic_id)
    end
end
