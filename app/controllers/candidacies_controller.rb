class CandidaciesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @candidacies = current_user.candidacies.joins(race: :election).where(Election.arel_table[:election_type].eq(Election::ELECTION_TYPE_INTERNAL))
    @races = Race.active_for_time(Time.now)

    breadcrumbs candidacies_breadcrumbs(include_link: false)
  end

  def new
    @race = Race.find(params[:race_id])
    @candidacy = Candidacy.new(race: @race, user: current_user)
    if @race.election.internal?
      @candidacy.answers = @race.questionnaire.new_answers
      breadcrumbs candidacies_breadcrumbs, "New Candidacy"
    else
      breadcrumbs candidacies_breadcrumbs, "New Candidacy"
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
    @candidacy = Candidacy.new(candidacy_params(params))
    @candidacy.created_by_user = current_user
    if @candidacy.save
      if @race.election.internal?
        redirect_to root_path
      else
        redirect_to @race
      end
    else
      render 'new'
    end
  end

  def edit
    # @race = Race.find(params[:race_id])
    @candidacy = Candidacy.find(params[:id])
    @race = @candidacy.race

    @candidacy.answers.each do |answer|
      if answer.question.question_type == Question::QUESTION_TYPE_CHECKBOXES
        if answer && answer.text
          answer.text_checkboxes = answer.text.split(/ /).reject{|a| a.blank?}
        else
          answer.text_checkboxes = ''
        end
      end
    end

    breadcrumbs candidacies_breadcrumbs, @candidacy.race.complete_name
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
        redirect_to @candidacy.race
      end
    else
      render 'edit'
    end
  end

  def destroy
    @candidacy = Candidacy.find(params[:id])
    race = @candidacy.race

    @candidacy.destroy

    if race.election.internal?
      redirect_to root_path
    else
      redirect_to @candidacy.race
    end
  end

  def self.answers_atributes
    [:text, :question_id, :order_index, :candidacy_id, :id]
  end

  def self.candidacy_attributes
    [:race_id, :user_id, :name, :party_affiliation, :notes, {answers_attributes: answers_atributes}]
  end

  private

  def candidacy_params(params)
    params.require(:candidacy).permit(*self.class.candidacy_attributes)
  end

  def candidacies_breadcrumbs(include_link: true)
    ["Candidacies", include_link ? candidacies_path : nil]
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
