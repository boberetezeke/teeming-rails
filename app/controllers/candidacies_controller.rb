class CandidaciesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_context
  before_action :set_context_params

  def index
    @candidacies = current_user.candidacies.joins(race: :election).where(Election.arel_table[:election_type].eq(Election::ELECTION_TYPE_INTERNAL))
    @races = Race.active_for_time(Time.now)

    breadcrumbs candidacies_breadcrumbs(include_link: false)
  end

  def show
    @candidacy = Candidacy.find(params[:id])
    authorize @candidacy

    setup_answer_checkboxes

    breadcrumbs candidacies_breadcrumbs, @candidacy.name
  end

  def new
    @race = Race.find(params[:race_id])
    if @race.election.internal? && !@race.before_filing_deadline?(Time.now.utc)
      flash[:alert] = 'the filing deadline is past'
      redirect_to candidacies_path
    else
     if @race.election.internal?
        @candidacy = Candidacy.new(race: @race, user: current_user)
     else
       @candidacy = Candidacy.new(race: @race)
     end

      if @race.election.internal?
        @candidacy.answers = @race.questionnaire.new_answers
        breadcrumbs candidacies_breadcrumbs, "New Candidacy"
      else
        breadcrumbs candidacies_breadcrumbs, "New Candidacy"
      end
    end
  end

  def create
    if params['candidacy']['answers_attributes']
      params['candidacy']['answers_attributes'].values.each do |answer_params|
        if answer_params['text_checkboxes'].is_a?(Array)
          answer_params['text'] = answer_params['text_checkboxes'].join(' ')
        end
      end
    end

    @race = Race.find(params[:candidacy][:race_id])
    if @race.election.internal? && !@race.before_filing_deadline?(Time.now.utc)
      flash[:alert] = 'the filing deadline is past'
      redirect_to root_path
    else
      @candidacy = Candidacy.new(candidacy_params(params))
      @candidacy.created_by_user = current_user

      @chapter = @race.chapter
      set_context_params

      if @candidacy.save
        if @race.election.internal?
          redirect_to root_path
        else
          redirect_to race_path(@race, @context_params)
        end
      else
        breadcrumbs candidacies_breadcrumbs, @candidacy.name
        render 'new'
      end
    end
  end

  def edit
    # @race = Race.find(params[:race_id])
    @candidacy = Candidacy.find(params[:id])
    @race = @candidacy.race

    setup_answer_checkboxes

    breadcrumbs candidacies_breadcrumbs, @candidacy.name
  end

  def update
    @candidacy = Candidacy.find(params[:id])
    @candidacy.updated_by_user = current_user

    if params['candidacy']['answers_attributes']
      params['candidacy']['answers_attributes'].values.each do |answer_params|
        if answer_params['text_checkboxes'].is_a?(Array)
          answer_params['text'] = answer_params['text_checkboxes'].join(' ')
        end
      end
    end

    if @candidacy.update(candidacy_params(params))
      if @candidacy.race.election.internal?
        redirect_to root_path
      else
        @race = @candidacy.race
        @chapter = @race.chapter
        set_context_params

        redirect_to race_path(@candidacy.race, @context_params)
      end
    else
      render 'edit'
    end
  end

  def unlock
    @candidacy = Candidacy.find(params[:id])

    @candidacy.update(questionnaire_submitted_at: nil)

    flash[:notice] = "#{@candidacy.name} unlocked"
    redirect_to race_path(@candidacy.race, @context_params)
  end

  def destroy
    @candidacy = Candidacy.find(params[:id])
    race = @candidacy.race

    @candidacy.destroy

    if race.election.internal?
      redirect_to root_path
    else
      redirect_to race_path(@candidacy.race, @context_params)
    end
  end

  def self.answers_atributes
    [:text, :question_id, :order_index, :candidacy_id, :id]
  end

  def self.candidacy_attributes
    [:race_id, :user_id, :name, :party_affiliation, :email, :notes, {answers_attributes: answers_atributes}]
  end

  private

  def setup_answer_checkboxes
    @candidacy.answers.each do |answer|
      if answer.question.question_type == Question::QUESTION_TYPE_CHECKBOXES
        if answer && answer.text
          answer.text_checkboxes = answer.text.split(/:::/).reject{|a| a.blank?}
        else
          answer.text_checkboxes = ''
        end
      end
    end
  end

  def set_context
    if params[:chapter_id]
      @chapter = Chapter.find(params[:chapter_id])
    end
    if params[:race_id]
      @race = Race.find(params[:race_id])
    end
  end

  def set_context_params
    @context_params = {}
    @context_params[:chapter_id] = @chapter.id if @chapter
    @context_params[:race_id] = @race.id       if @race
  end

  def candidacy_params(params)
    params.require(:candidacy).permit(*self.class.candidacy_attributes)
  end

  def candidacies_breadcrumbs(include_link: true)
    if @race
      [@race.complete_name, race_path(@race, @context_params)]
    else
      [@candidacy.race.complete_name, include_link ? race_path(@candidacy.race, @context_params) : nil]
    end
  end
end

# add_foreign_key "answers", "candidacies"
# add_foreign_key "answers", "questions"
# add_foreign_key "candidacies", "races"
# add_foreign_key "candidacies", "users"
# add_foreign_key "candidate_assignments", "answers", column: "answers_id"
# add_foreign_key "candidate_assignments", "roles"
# add_foreign_key "candidate_assignments", "users"
# add_foreign_key "elections", "chapters"
# add_foreign_key "questionnaires", "races"
# add_foreign_key "questions", "questionnaires"
# add_foreign_key "races", "elections"
# add_foreign_key "races", "roles"
# add_foreign_key "role_assignments", "chapters"
# add_foreign_key "role_assignments", "roles"
# add_foreign_key "role_assignments", "users"
# add_foreign_key "roles", "chapters"
# add_foreign_key "users", "affiliates", column: "affiliates_id"
