class UsersController < ApplicationController
  before_filter :authenticate_user!

  STATES = ['step_setup_user_details', 'step_agree_to_bylaws', 'step_declare_candidacy']

  def index
    @users = User.all
  end

  def home
    @user = current_user
    @user.member = Member.new unless @user.member
    @race = Race.find(1)
    @user.candidacies.build(race: @race, user: current_user, answers: @race.questionnaire.questions.map{|q| q.new_answer})
  end

  def profile
    @user = current_user
  end

  def accept_bylaws
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
      if @user.setup_state == 'step_declare_candidacy'&& params[:user][:run_for_state_board] == '0'
        params[:user].delete(:candidacies_attributes)
      end

      if @user.update(user_params(params))
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

  def user_params(params)
    params.require(:user).permit(:accepted_bylaws,
                                 {member_attributes: [
                                    :first_name, :last_name, :middle_initial, :mobile_phone, :home_phone, :work_phone,
                                    :address_1, :address_2, :city, :state, :zip, :chapter_id
                                 ]},
                                 {candidacies_attributes: [CandidaciesController.candidacy_attributes]})
  end
end