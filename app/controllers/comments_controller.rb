class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comment = Comment.all
  end

  def show
  end

  def new
    if user_signed_in?
      @comment = Comment.new
    else
      redirect_to general_forum_topics_path, notice: 'You must be logged in to comment.'
    end
  end

  def edit
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
  end

  def destroy
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
