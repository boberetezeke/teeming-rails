class UsersController < ApplicationController
  before_filter :authenticate_user!

  STATES = ['step_setup_user_details', 'step_volunteer_or_donate', 'step_declare_candidacy']

  def home
    @user = current_user

    @setup_state = @user.setup_state
    if @setup_state.present?
      @setup_states_index = STATES.index(@setup_state) + 1
      @setup_states_total = STATES.size

      convert_answer_checkboxes_from_text
      # for user info page
      @user.member = Member.new unless @user.member
      @user.member.with_user_input = true

      # for candidancies page
      @race = Race.find_by_name('Initial Board Election Race')

      # HACK - delete existing candidacy to avoid save error - Couldn't find Answer with ID=346 for Candidacy with ID=
      if @user.candidacies.present?
        @user.candidacies.destroy_all
      end

      @user.candidacies.build(race: @race, user: current_user, answers: @race.questionnaire.new_answers)

      if @user.event_rsvps.present?
        @user.event_rsvps.destroy_all
      end

      @initial_convention = Event.first
      @user.event_rsvps.build(user: current_user, event: @initial_convention)
    end
  end

  def privacy_policy
  end

  def bylaws
  end

  def code_of_conduct
  end

  def redo_initial_steps
    current_user.update(setup_state: 'step_setup_user_details', saw_introduction: false)
    redirect_to home_users_path
  end

  def profile
    @user = current_user
    convert_answer_checkboxes_from_text

    breadcrumbs "My Profile"
  end

  def account
    @user = current_user

    breadcrumbs "My Account"
  end

  def accept_bylaws
    @user = current_user

    breadcrumbs "Accept Bylaws"
  end

  def update
    @user = User.find(params[:id])
    if params[:commit] == 'Previous Step'
      @user.setup_state = previous_state
      @user.save
      redirect_to home_users_path
    elsif params[:commit] == 'Cancel'
      flash[:notice] = "You have cancelled your new user setup. You can complete your profile, and declare a candidacy by selecting them in the User menu."
      @user.setup_state = ''
      @user.save
      redirect_to home_users_path
    else
      declaring_candidacy_and_beyond_filing_deadline = false
      if @user.setup_state == 'step_declare_candidacy'
        @race = Race.find_by_name('Initial Board Election Race')
        if params[:user][:run_for_state_board] == '0'
          params[:user].delete(:candidacies_attributes)
        else
          declaring_candidacy_and_beyond_filing_deadline = !(@race.before_filing_deadline?(Time.now.utc))
          if params['user']['candidacies_attributes']
            params['user']['candidacies_attributes'].values[0]['answers_attributes'].values.each do |answer_params|
              convert_answer_checkboxes_to_text(answer_params)
            end
          end
        end

        if params[:user][:event_rsvps_attributes].nil?
          params[:user][:event_rsvps_attributes] = {"0" => {"rsvp_type" => ""}}
        end
      end

      if params['user']['answers_attributes']
        params['user']['answers_attributes'].values.each do |answer_params|
          convert_answer_checkboxes_to_text(answer_params)
        end
      end

      if @user.update(user_params(params)) && !declaring_candidacy_and_beyond_filing_deadline
        if @user.setup_state.present?
          @user.reload
          @user.setup_state = next_state
          @user.save
        end

        redirect_to home_users_path
      else
        if declaring_candidacy_and_beyond_filing_deadline
          flash[:error] = 'the filing deadline is past'
        end
        @initial_convention = Event.first
        render 'home'
      end
    end
  end

  def update_email
    @user = User.find(params[:id])
    if @user.update(user_params(params))
      flash[:notice] = "An email has been sent to you to confirm your email change. The change won't take effect until you click the confirmation link."
      redirect_to root_path
    else
      render 'account'
    end
  end

  def update_password
    @user = User.find(params[:id])
    if @user.update(user_params(params))
      redirect_to root_path
    else
      render 'account'
    end
  end

  def destroy
    @user = User.find(params[:id])
    # @user.destroy
    redirect_to root_path
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
    params.require(:user).permit(:accepted_bylaws, :interested_in_volunteering, :run_for_state_board, :saw_introduction,
                                 :email, :password, :password_confirmation,
                                 {answers_attributes: CandidaciesController.answers_atributes},
                                 {event_rsvps_attributes: [:rsvp_type, :event_id] },
                                 {member_attributes: [
                                    :first_name, :last_name, :middle_initial, :mobile_phone, :home_phone, :work_phone,
                                    :address_1, :address_2, :city, :state, :zip, :chapter_id, :interested_in_starting_chapter,
                                    :with_user_input
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