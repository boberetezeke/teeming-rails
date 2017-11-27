class CandidateQuestionnairesController < ApplicationController
  before_action :set_candidacy

  def show
    if @candidacy
      #if !@candidacy.questionnaire_submitted
        redirect_to root_path
      #end
    end
  end

  def edit
    if @candidacy
      if @candidacy.answers.empty?
        @candidacy.answers = @candidacy.race.questionnaire.new_answers
      end

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
  end

  def update
    if @candidacy

      if params['candidacy']['answers_attributes']
        params['candidacy']['answers_attributes'].values.each do |answer_params|
          if answer_params['text_checkboxes'].is_a?(Array)
            answer_params['text'] = answer_params['text_checkboxes'].join(':::')
          end
        end
      end

      if @candidacy.update(candidacy_params)
        if params[:commit] == "Update"
          flash[:notice] = "Questionnaire updated"
          redirect_to edit_candidate_questionnaire_path(@candidacy.token)
        elsif params[:commit] == "Request unlock"
          @candidacy.update(unlock_requested_at: Time.now.utc)
          flash[:notice] = "Unlock request submitted, someone will get in touch with you shortly"
          redirect_to edit_candidate_questionnaire_path(@candidacy.token)
        else
          flash[:notice] = "Questionnaire submitted and locked"
          @candidacy.update(questionnaire_submitted_at: Time.now.utc)
          redirect_to edit_candidate_questionnaire_path(@candidacy.token)
        end
      end
    end
  end

  private

  def candidacy_params
    params.require(:candidacy).permit(
        {
            answers_attributes: QuestionnairesController.permitted_answer_attributes
        }
    )
  end

  def set_candidacy
    @candidacy = Candidacy.find_by_token(params[:id])
    if !@candidacy
      flash[:alert] = "Candidate questionnaire not found"
      redirect_to root_path
    end
  end
end

