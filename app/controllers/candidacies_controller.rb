class CandidaciesController < ApplicationController
  def index
    @candidacies = Candidacy.all
    @races = Race.active_for_time(Time.now)
  end

  def new
    @race = Race.find(params[:race_id])
    @candidacy = Candidacy.new(race: @race, user: current_user)
    @candidacy.answers = @race.questionnaire.questions.map{|q| q.new_answer(@candidacy)}
  end

  def create
    @race = Race.find(params[:candidacy][:race_id])
    @candidacy = Candidacy.new(candidacy_params)
    if @candidacy.save
      redirect_to candidacies_path
    else
      render 'new'
    end
  end

  def edit
    @race = Race.find(params[:race_id])
    @candidacy = Candidacy.find(params[:id])
  end

  def update
    @candidacy = Candidacy.find(params[:id])
    if @candidacy.update(candidacy_params)
      redirect_to candidacies_path
    else
      render 'edit'
    end
  end

  def self.candidacy_attributes
    [:race_id, :user_id, {answers_attributes: [:text, :question_id, :candidacy_id, :id]}]
  end

  private

  def candidacy_params
    params.require(:candidacy).permit(*self.class.candidacy_attributes)
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
