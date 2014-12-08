class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update]
  before_action :set_comment, only: [:edit, :update]

  def new
    if @topic.closed
      redirect_to discussion_topic_path(@topic), alert: 'This discussion is closed.'
    else
      @topic = DiscussionTopic.find(params[:topic_id])
      @comment = Comment.new
    end
  end

  def edit
    if !(current_user.has_forum_access?)
      redirect_to discussion_topic_path(@topic)
    end
  end

  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to discussion_topic_path(@comment.discussion_topic), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to discussion_topic_path(@comment.discussion_topic), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :removed, :discussion_topic_id)
    end
end
