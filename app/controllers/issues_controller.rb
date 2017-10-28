class IssuesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @election = Election.find(params[:election_id])
    @issues = @election.issues
    breadcrumbs ["Elections", elections_path], issues_breadcrumbs(@election, include_link: false)
  end

  def show
    @issue = Issue.find(params[:id])
    authorize @issue
    if Pundit.policy(current_user, @issue.election).show? &&
      !Pundit.policy(current_user, @issue.election).edit?
      redirect_to @issue.questionnaire
    else
      breadcrumbs issues_breadcrumbs(@issue.election), @issue.name
      render 'show'
    end
  end

  def new
    @election = Election.find(params[:election_id])
    @issue = Issue.new(election: @election)
    breadcrumbs issues_breadcrumbs(@issue.election), "New Issue"
  end

  def create
    @issue = Issue.new(issue_params)

    @issue.created_by_user = current_user
    @issue.save

    respond_with @issue, location: issue_path(@issue)
  end

  def edit
    @issue = Issue.find(params[:id])
    breadcrumbs issues_breadcrumbs(@issue.election), @issue.name
  end

  def update
    @issue = Issue.find(params[:id])

    @issue.updated_by_user = current_user
    @issue.update(issue_params)

    respond_with @issue, location: issue_path(@issue)
  end

  def destroy
    @issue = Issue.find(params[:id])
    @election = @issue.election
    @issue.destroy

    redirect_to election_issues_path(@election)
  end

  def create_questionnaire
    issue = Issue.find(params[:id])
    questionnaire = Questionnaire.create(questionnairable: issue, name: issue.name)
    QuestionnaireSection.create(questionnaire: questionnaire, order_index: 1, title: 'First Section')

    redirect_to questionnaire
  end

  private

  def issue_params
    params.require(:issue).permit(:name, :election_id)
  end

  def issues_breadcrumbs(election, include_link: true)
    if election.external?
      ["#{election.name} Issues", include_link ? election_issues_path(election) : nil]
    else
      ["#{election.name}", include_link ? election_path(election) : nil]
    end
  end
end
