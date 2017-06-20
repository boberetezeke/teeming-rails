class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def home
    @user = current_user
    @bylaws = "Bylaws " * 200
  end

  def profile
    @user = current_user
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to home_users_path
    else
      render 'users/home'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :address_1, :address_2, :city, :state, :postal_code, :accepted_bylaws)
  end
end