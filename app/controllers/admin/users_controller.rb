class Admin::UsersController < ApplicationController

  before_action :check_permission
  before_action :load_user, except: %w(index new create)

  def index
    @users = User.where(:id.ne => current_user.id).all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(new_user_params)
    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  def edit
    render
  end

  def update
    if @user.update(edit_user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def reset_password
    @user.update(password: User::PASSWORD)
    redirect_to admin_users_path
  end

  private

  def check_permission
    current_user.admin? || raise(ActionController::RoutingError.new('Not Found'))
  end

  def load_user
    @user ||= User.find(params[:id])
  end

  def new_user_params
    params.require(:user).permit(:username, :first_name, :last_name, :active)
  end

  def edit_user_params
    params.require(:user).permit(:first_name, :last_name, :active)
  end

end
