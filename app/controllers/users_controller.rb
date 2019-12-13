class UsersController < ApplicationController
  before_action :authenticate_user!

  STATES = ['step_setup_user_details', 'step_volunteer_or_donate']

  def home
    @user = current_user
    if @user.selected_account.nil?
      return redirect_to select_account_users_path
    end

    # @title = "Our Revolution MN Membership"
    @title = "Membership"

    @setup_state = @user.setup_state
    if @setup_state.present?
      @setup_states_index = STATES.index(@setup_state) + 1
      @setup_states_total = STATES.size

      convert_answer_checkboxes_from_text

      # for user info page
      if @user.member
        @display_found_member_modal = !@user.member.added_with_new_user
      else
        existing_member = Member.find_by_email(@user.email)
        if existing_member
          @user.member = existing_member
          @display_found_member_modal = true
        else
          @user.member = Member.new(email: @user.email, added_with_new_user: true, message_controls: [
              MessageControl.new(unsubscribe_type: MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL,
                                 control_type: MessageControl::CONTROL_TYPE_NEUTRAL),
              MessageControl.new(unsubscribe_type: MessageControl::CONTROL_SUBSCRIPTION_TYPE_TEXT,
                                 control_type: MessageControl::CONTROL_TYPE_NEUTRAL),
          ])
        end
      end

      @user.member.with_user_input = true
    else
      @events = policy_scope(Event.future.visible(nil))
      @elections = policy_scope(Election.show_on_dashboard(nil).visible(nil))
    end
  end

  def select_account
    @accounts = Account.all
  end

  def select2
    @chapter = Chapter.find(params[:chapter_id])
    if params[:term].present?
      if @chapter.is_state_wide
        @users = Member.all_members(@chapter).filtered_by_string(params[:term]).with_user.includes(:user).limit(50).map(&:user)
      else
        @users = @chapter.members.filtered_by_string(params[:term]).with_user.includes(:user).limit(50).map(&:user)
      end
    else
      @users = []
    end
    respond_to do |format|
      format.json { render(json: {results: @users.map{|user| {text: "#{user.member.name} (#{user.email})", id: user.id}}}.to_json) }
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

  def privacy
    @user = current_user

    breadcrumbs "My Privacy"
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
        if !(params[:user][:run_for_state_board]) || params[:user][:run_for_state_board] == '0'
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

      if params['user']['member_attributes'] && params['user']['member_attributes']['answers_attributes']
        params['user']['member_attributes']['answers_attributes'].values.each do |answer_params|
          convert_answer_checkboxes_to_text(answer_params)
        end
      end

      if @user.update(user_params(params)) && !declaring_candidacy_and_beyond_filing_deadline
        if @user.setup_state.present?
          @user.reload
          if @user.setup_state == 'step_setup_user_details'
            # now = Time.zone.now
            # elections = Election.all.select{|e| e.vote_start_time && e.vote_end_time && now >= e.vote_start_time && now < e.vote_end_time}
            # elections.each do |election|
            #   election.vote_completions << VoteCompletion.create(election: election, user: @user, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE)
            # end
          end
          @user.setup_state = next_state
          @user.save
        end

        redirect_to home_users_path
      else
        if declaring_candidacy_and_beyond_filing_deadline
          flash[:alert] = 'the filing deadline is past'
        end
        @initial_convention = Event.first
        render 'home'
      end
    end
  end

  def update_email
    @user = User.find(params[:id])
    if @user.update(user_params(params))
      # HACK: temporary way to keep user email and member email in sync. Should override confirmations controller
      @user.member.update(email: @user.unconfirmed_email)
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

  def with_roles
    @users = User.with_roles
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
                                 :share_name, :share_email, :share_phone, :share_address, :use_username,
                                 {event_rsvps_attributes: [:rsvp_type, :event_id] },
                                 {member_attributes: [
                                    :id,
                                    :email, :first_name, :last_name, :middle_initial, :mobile_phone, :home_phone, :work_phone,
                                    :address_1, :address_2, :city, :state, :zip, :chapter_id, :interested_in_starting_chapter,
                                    :with_user_input, :bio,
                                    {answers_attributes: CandidaciesController.answers_atributes},
                                    {message_controls_attributes: [:unsubscribe_type, :control_type, :id]}
                                 ]},
                                 {candidacies_attributes: [CandidaciesController.candidacy_attributes]})
  end

  private

  def convert_answer_checkboxes_to_text(answer_params)
    if answer_params['text_checkboxes'].is_a?(Array)
      answer_params['text'] = answer_params['text_checkboxes'].join(':::')
    end
  end

  def convert_answer_checkboxes_from_text
    return unless Chapter.state_wide && Chapter.state_wide.skills_questionnaire

    if @user.member
      if @user.member.answers.empty?
        @user.member.answers = Chapter.state_wide.skills_questionnaire.new_answers(user: @user)
      else
        @user.member.answers.each do |answer|
          if answer.question.question_type == Question::QUESTION_TYPE_CHECKBOXES
            if answer.text
              answer.text_checkboxes = answer.text.split(/:::/).reject{|a| a.blank?}
            else
              answer.text_checkboxes = []
            end
          end
        end
      end
    end
  end

end