class DiscussionTopicsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_discussion_topic, only: [:show, :edit, :update, :destroy]

  def index
    #@topic = DiscussionTopic.all
    if params.has_key? :forum_id
      @forum = GeneralForumTopic.find params[:forum_id]
      @topics = @forum.discussion_topics
      @topics = @topics.sort_by(&:created_at).reverse
    else
      redirect_to general_forum_topics_path
    end
  end

  def show
    @comments = @topic.comments.sort_by(&:created_at).reverse
  end

  def new
    @topic = DiscussionTopic.new
  end

  def edit
    if !(valid_user(@topic.user_id) or user_admin?)
      redirect_to discussion_topics_path(forum_id: @topic.general_forum_topic.id), alert: 'You cannot edit this topic.'
    end
  end

  def create
    @topic = DiscussionTopic.new(discussion_topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'DiscussionTopic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update(discussion_topic_params)
        format.html { redirect_to @topic, notice: 'DiscussionTopic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to discussion_topics_url, notice: 'DiscussionTopic was successfully destroyed.' }
      format.json { head :no_content }
    end
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
