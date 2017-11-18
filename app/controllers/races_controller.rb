class RacesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_chapter
  before_action :set_chapter_params

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
    set_chapter_params

    respond_with @race, location: race_path(@race, @chapter_params)
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
    set_chapter_params

    respond_with @race, location: race_path(@race, @chapter_params)
  end

  def create_questionnaire
    race = Race.find(params[:id])
    questionnaire = Questionnaire.create(questionnairable: race, name: race.name)
    QuestionnaireSection.create(questionnaire: questionnaire, order_index: 1, title: 'First Section')

    redirect_to questionnaire_path(questionnaire, @chapter_params)
  end

  def email_questionnaire
    race = Race.find(params[:id])
    flash[:notice] = "Questionnaire emailed out to candidates"
    redirect_to race_path(race, @chapter_params)
  end

  def delete_questionnaire
    race = Race.find(params[:id])

    race.questionnaire.destroy

    redirect_to race_path(race, @chapter_params)
  end

  def destroy
    @race = Race.find(params[:id])
    @election = @race.election
    @race.destroy

    redirect_to election_races_path(@election, @chapter_params)
  end

  private

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end

  def set_chapter_params
    @chapter_params = @chapter ? { chapter_id: @chapter.id } : {}
  end

  def race_params
    params.require(:race).permit(:name, :election_id, :chapter_id, :level_of_government, :locale, :notes, :filing_deadline_date_str, :candidates_announcement_date_str)
  end

  def races_breadcrumbs(election, include_link: true)
    if election.external?
      ["#{election.name} Races", include_link ? election_races_path(election, @chapter_params) : nil]
    else
      ["#{election.name}", include_link ? election_path(election, @chapter_params) : nil]
    end
  end
end