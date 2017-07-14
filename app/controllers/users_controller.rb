class UsersController < ApplicationController
  before_filter :authenticate_user!

  STATES = ['step_setup_user_details', 'step_agree_to_bylaws', 'step_volunteer_or_donate', 'step_declare_candidacy']

  def index
    @users = User.all
  end

  def home
    @user = current_user

    @setup_state = @user.setup_state
    if @setup_state.present?
      @setup_states_index = STATES.index(@setup_state) + 1
      @setup_states_total = STATES.size

      convert_answer_checkboxes_from_text
      # for user info page
      @user.member = Member.new unless @user.member

      # for candidancies page
      @race = Race.order('id asc').first
      @user.candidacies.build(race: @race, user: current_user, answers: @race.questionnaire.new_answers)
    end
  end

  def profile
    @user = current_user
    convert_answer_checkboxes_from_text
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
      if @user.setup_state == 'step_declare_candidacy'
        if params[:user][:run_for_state_board] == '0'
          params[:user].delete(:candidacies_attributes)
        else
          params['user']['candidacies_attributes'].values[0]['answers_attributes'].values.each do |answer_params|
            convert_answer_checkboxes_to_text(answer_params)
          end
        end
      end

      if params['user']['answers_attributes']
        params['user']['answers_attributes'].values.each do |answer_params|
          convert_answer_checkboxes_to_text(answer_params)
        end
      end

      if @user.update(user_params(params))
        if @user.setup_state.present?
          @user.reload
          @user.setup_state = next_state
          @user.save
        end

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
    params.require(:user).permit(:accepted_bylaws, :interested_in_volunteering, :run_for_state_board,
                                 {answers_attributes: CandidaciesController.answers_atributes},
                                 {member_attributes: [
                                    :first_name, :last_name, :middle_initial, :mobile_phone, :home_phone, :work_phone,
                                    :address_1, :address_2, :city, :state, :zip, :chapter_id, :interested_in_starting_chapter
                                 ]},
                                 {candidacies_attributes: [CandidaciesController.candidacy_attributes]})
  end

  private

  def convert_answer_checkboxes_to_text(answer_params)
    if answer_params['text_checkboxes'].is_a?(Array)
      answer_params['text'] = answer_params['text_checkboxes'].join(' ')
    end
  end

  def convert_answer_checkboxes_from_text
    if @user.answers.empty?
      @user.answers = Chapter.state_wide.skills_questionnaire.new_answers
    else
      @user.answers.each do |answer|
        if answer.question.question_type == Question::QUESTION_TYPE_CHECKBOXES
          if answer.text
            answer.text_checkboxes = answer.text.split(/ /).reject{|a| a.blank?}
          else
            answer.text_checkboxes = []
          end
        end
      end
    end
  end

end