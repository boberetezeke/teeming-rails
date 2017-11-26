class RacesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_race, only: [:show, :edit, :update, :destroy]

  before_action :set_context
  before_action :set_context_params

  def index
    @election = Election.find(params[:election_id])
    @races = @election.races
    @races = @races.for_chapter(@chapter) if @chapter
    if @chapter
      breadcrumbs [@chapter.name, @chapter], races_breadcrumbs(@election, include_link: false)
    else
      breadcrumbs ["Elections", elections_path], races_breadcrumbs(@election, include_link: false)
    end
  end

  def show
    @race = Race.find(params[:id])
    authorize @race

    # set this for view from the race
    @context_params[:race_id] = @race.id

    breadcrumbs races_breadcrumbs(@race.election), @race.complete_name
  end

  def new
    @election = Election.find(params[:election_id])
    @race = Race.new({election: @election}.merge(chapter: @chapter))
    breadcrumbs races_breadcrumbs(@race.election), "New Race"
  end

  def create
    @race = Race.new(race_params)

    @race.created_by_user = current_user
    @race.save
    @chapter = @race.chapter
    set_context_params

    respond_with @race, location: race_path(@race, @context_params)
  end

  def edit
    @race = Race.find(params[:id])
    @race.set_accessors
    breadcrumbs races_breadcrumbs(@race.election), @race.complete_name
  end

  def update
    @race = Race.find(params[:id])

    @race.updated_by_user = current_user
    @race.update(race_params)
    @chapter = @race.chapter
    set_context_params

    respond_with @race, location: race_path(@race, @context_params)
  end

  def create_questionnaire
    race = Race.find(params[:id])
    questionnaire = Questionnaire.create(questionnairable: race, name: race.name)
    QuestionnaireSection.create(questionnaire: questionnaire, order_index: 1, title: 'First Section')

    redirect_to questionnaire_path(questionnaire, @context_params)
  end

  def email_questionnaire
    race = Race.find(params[:id])
    if @context_params[:chapter_id]
      redirect_to new_chapter_message_path(@context_params.merge(race_id: race.id))
    else
      redirect_to new_message_path(@context_params.merge(race_id: race.id))
    end
  end

  def copy_questionnaire
    race = Race.find(params[:id])
    questionnaire = Questionnaire.find(params[:race][:questionnaire])
    race.update(questionnaire: questionnaire.copy)

    redirect_to race_path(race, @context_params)
  end

  def delete_questionnaire
    race = Race.find(params[:id])

    race.questionnaire.destroy

    redirect_to race_path(race, @context_params)
  end

  def destroy
    @election = @race.election
    @race.destroy

    redirect_to election_races_path(@election, @context_params)
  end

  private

  def set_race
    @race = Race.find(params[:id])
    authorize @race
  end

  def set_context
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end

  def set_context_params
    @context_params = @chapter ? { chapter_id: @chapter.id } : {}
  end

  def race_params
    params.require(:race).permit(:name, :election_id, :chapter_id, :level_of_government, :locale, :notes, :filing_deadline_date_str, :candidates_announcement_date_str, :is_official)
  end

  def races_breadcrumbs(election, include_link: true)
    if election.external?
      ["#{election.name} Races", include_link ? election_races_path(election, @context_params) : nil]
    else
      ["#{election.name}", include_link ? election_path(election, @context_params) : nil]
    end
  end
end