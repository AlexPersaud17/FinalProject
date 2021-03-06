class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    if logged_in?
      @user = current_user
    else
      render "errors/lost"
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user
      UserMailer.welcome_email(@user).deliver!
    else
      @errors = @user.errors.full_messages
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)
    if @user.save
      redirect_to @user
    else
      @errors = @user.errors.full_messages
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
