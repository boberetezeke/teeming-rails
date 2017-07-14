class CandidaciesController < ApplicationController
  def index
    @candidacies = Candidacy.all
    @races = Race.active_for_time(Time.now)
  end

  def new
    @race = Race.find(params[:race_id])
    @candidacy = Candidacy.new(race: @race, user: current_user)
    @candidacy.answers = @race.questionnaire.new_answers
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

    @candidacy.answers.each do |answer|
      if answer.question.question_type == Question::QUESTION_TYPE_CHECKBOXES
        answer.text_checkboxes = answer.text.split(/ /).reject{|a| a.blank?}
      end
    end
  end

  def update
    @candidacy = Candidacy.find(params[:id])

    params['candidacy']['answers_attributes'].values.each do |answer_params|
      if answer_params['text_checkboxes'].is_a?(Array)
        answer_params['text'] = answer_params['text_checkboxes'].join(' ')
      end
    end

    if @candidacy.update(candidacy_params(params))
      redirect_to candidacies_path
    else
      render 'edit'
    end
  end

  def self.answers_atributes
    [:text, :question_id, :order_index, :candidacy_id, :id]
  end

  def self.candidacy_attributes
    [:race_id, :user_id, {answers_attributes: answers_atributes}]
  end

  private

  def candidacy_params(params)
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
