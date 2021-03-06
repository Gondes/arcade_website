class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy, :reset_stats]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :reset_stats]

  helper_method :sort_column, :sort_direction

  # GET /users
  # GET /users.json
  def index
    amount = 25
    @users = User.order(sort_column + " " + sort_direction)

    if !(params[:page].nil?) && (params[:page].to_i > 0)
      @last_page = (@users.count - 1) / amount + 1
      @next_available = (( @users.limit(amount).offset((amount) * (params[:page].to_i)) ).size > 0)
      @previous_available = params[:page].to_i > 1
      @users = @users.limit(amount).offset(amount * (params[:page].to_i - 1))
    else
      redirect_to users_url(:page => 1)
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if (@user.is_hidden? && !current_user.has_user_access? && @user.id != current_user.id)
      redirect_to users_url
    end
  end

  # GET /users/new
  def new
    if !(user_signed_in?) or user_exists
      redirect_to users_url
    else
      @user = User.new
    end
  end

  # GET /users/1/edit
  def edit
    #if !(valid_user(@user.id) or !current_user.has_user_access?)
    if valid_user(@user.id) or current_user.has_user_access?
      
    else
      redirect_to users_url
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reset_stats
    @user = User.find(params[:id])
    @user.reset_stats
    @user.save!
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully reset.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :user_name, :games_played_count,
        :wins_count, :loss_count, :tie_count, :best_win_streak, :current_win_streak, :email,
        :encrypted_password, :icon, :is_disabled, :is_hidden, :coins, :exp, :level, :admin,
        :forum_access, :user_stat_access, :user_profile_access, :game_access, :give_access,
        :password )
    end

    # These two methods are used to make the table sortable.
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "user_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
