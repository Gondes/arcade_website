class DiscussionTopicsController < ApplicationController
  before_action :authenticate_new, only:[:new]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_discussion_topic, only: [:show, :edit, :update, :destroy]

  def index
    amount = 25
    if !params[:forum_id].nil?
      @forum = GeneralForumTopic.find params[:forum_id]
      @topics = @forum.discussion_topics
      @topics = @topics.order(created_at: :desc)

      if !(params[:page].nil?) && (params[:page].to_i > 0)
        @next_available = (( @topics.limit(amount).offset((amount) * (params[:page].to_i)) ).size > 0)
        @previous_available = params[:page].to_i > 1
        @topics = @topics.limit(amount).offset(amount * (params[:page].to_i - 1))
      else
        redirect_to discussion_topics_url(:forum_id => params[:forum_id].to_i, :page => 1)
      end
    else
      redirect_to general_forum_topics_path
    end
  end

  def show
    amount = 10
    @comments = @topic.comments.order(created_at: :asc)
    if !(params[:page].nil?) && (params[:page].to_i > 0)
      @next_available = (( @comments.limit(amount).offset((amount) * (params[:page].to_i)) ).size > 0)
      @previous_available = params[:page].to_i > 1
      @comments = @comments.limit(amount).offset(amount * (params[:page].to_i - 1))
    else
      redirect_to discussion_topic_url(@topic, :page => 1)
    end
  end

  def authenticate_new
    if !(params[:forum_id].to_i == 1 or params[:forum_id].to_i == 4) and current_user.has_forum_access?
      redirect_to general_forum_topics_path
    end
  end

  def new
    @topic = DiscussionTopic.new
  end

  def edit
    if !(valid_user(@topic.user_id) or current_user.has_forum_access?)
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
