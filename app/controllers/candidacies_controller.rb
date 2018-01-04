class CandidaciesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_context
  before_action :set_context_params

  def index
    @candidacies = current_user.candidacies.joins(race: :election).where(Election.arel_table[:election_type].eq(Election::ELECTION_TYPE_INTERNAL))
    @races = Race.active_for_time(Time.now)

    breadcrumbs candidacies_breadcrumbs(include_link: false)
  end

  def with_completed_questionnaires
    @election = Election.find(params[:election_id])
    if @election.external?
      @candidacies = Candidacy.joins(:race => :election).where(
          Race.arel_table[:election_id].eq(@election.id).and(
              Candidacy.arel_table[:questionnaire_submitted_at].not_eq(nil)
          )
      )

      breadcrumbs candidacies_breadcrumbs(include_link: false), "Candidates"
    else
      flash[:alert] = "can't view completed questionnaires for internal elections"
      redirect_to root_path
    end
  end


  def show
    @candidacy = Candidacy.find(params[:id])
    authorize @candidacy

    Answer.translate_choice_text(@candidacy.answers)

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
    Answer.translate_choice_params(params['candidacy']['answers_attributes'])

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

    Answer.translate_choice_text(@candidacy.answers)

    breadcrumbs candidacies_breadcrumbs, @candidacy.name
  end

  def update
    @candidacy = Candidacy.find(params[:id])
    @candidacy.updated_by_user = current_user

    Answer.translate_choice_params(params['candidacy']['answers_attributes'])

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
    Answer.translate_choice_text(answers)
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
    if @election
      [@election.name, election_races_path(@election, @context_params)]
    elsif @race
      [@race.complete_name, race_path(@race, @context_params)]
    elsif @candidacy
      [@candidacy.race.complete_name, include_link ? race_path(@candidacy.race, @context_params) : nil]
    else
      ["Home", root_path]
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
