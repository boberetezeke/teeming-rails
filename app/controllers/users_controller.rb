class UsersController < ApplicationController
  before_filter :authenticate_user!

  STATES = ['step_setup_user_details', 'step_agree_to_bylaws', 'step_declare_candidacy']

  def index
    @users = User.all
  end

  def home
    @user = current_user
    @race = Race.find(1)
  end

  def profile
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if params[:commit] == 'Previous Step'
      @user.setup_state = previous_state
      @user.save
      redirect_to home_users_path
    elsif params[:commit] == 'Cancel'
      flash[:notice] = "You have cancelled your new user setup. You can complete your profile, accept the bylaws and declare a candidacy by selecting them in the User menu."
      @user.setup_state = ''
      @user.save
      redirect_to home_users_path
    else
      if @user.update(user_params)
        @user.setup_state = next_state
        @user.save
        redirect_to home_users_path
      else
        render 'users/home'
      end
    end
  end

  private

  def next_state
    index = STATES.index(@user.setup_state)
    if index.nil? || index == STATES.size - 1
      ''
    else
      STATES[index+1]
    end
  end

  def previous_state
    index = STATES.index(@user.setup_state)
    if index.nil?
      ''
    elsif index == 0
      @user.setup_state
    else
      STATES[index-1]
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :address_1, :address_2, :city, :state, :postal_code, :accepted_bylaws)
  end
end