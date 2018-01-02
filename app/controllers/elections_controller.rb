class ElectionsController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_election, only: [:show, :edit, :update, :destroy, :unfreeze, :freeze]
  before_action :set_chapter
  before_action :set_context_params

  def index
    authorize_with_args Election, @context_params

    @internal_elections = Election.internal
    @external_elections = Election.external

    breadcrumbs *elections_breadcrumbs(include_link: false)
  end

  def show
    @chapter = @election.chapter
    set_context_params
    breadcrumbs elections_breadcrumbs, @election.name
  end

  def new
    @election = Election.new(election_type: Election::ELECTION_TYPE_INTERNAL, election_method: Election::ELECTION_METHOD_ONLINE_AND_OFFLINE)
    authorize_with_args @election, @context_params

    @chapters = authorized_associated_objects(@election, :chapters)
    if @chapter
      @election.chapter = @chapter
    end
    @member_groups = MemberGroupPolicy::Scope.new(current_user, MemberGroup).resolve
    breadcrumbs elections_breadcrumbs, 'New election'
  end

  def create
    @election = Election.new(election_params)
    @election.save

    respond_with(@election)
  end

  def edit
    @election.set_accessors
    @member_groups = MemberGroupPolicy::Scope.new(current_user, MemberGroup).resolve
    @chapters = authorized_associated_objects(@election, :chapters)
    breadcrumbs elections_breadcrumbs, "Edit #{@election.name}"
  end

  def update
    @election.update(election_params)

    respond_with(@election)
  end

  def freeze
    @election.update(is_frozen: true)

    @election.voters.each do |member|
      user = member.user
      if user
        VoteCompletion.create(election: @election, user: user, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE)
      end
    end

    @election.questionnaire = Questionnaire.new
    @election.issues.each do |issue|
      @election.questionnaire.append_questionnaire_sections(issue.questionnaire)
    end

    redirect_to @election
  end

  def unfreeze
    @election.update(is_frozen: false)
    @election.vote_completions.destroy_all
    @election.questionnaire.destroy
    redirect_to @election
  end

  def destroy
    @election.destroy
    redirect_to @chapter ? @chapter : elections_path
  end

  private

  def set_election
    @election = Election.find(params[:id])
    authorize @election
  end

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end

  def set_context_params
    @context_params = @chapter ? { chapter_id: @chapter.id } : {}
  end

  def election_params
    params.require(:election).permit(:name, :chapter_id, :election_type, :election_method, :vote_date_str, :vote_start_time_str, :vote_end_time_str, :member_group_id)
  end

  def elections_breadcrumbs(include_link: true)
    if include_link
      if @chapter
        [@chapter.name, @chapter]
      else
        ["Elections", elections_path(@context_params)]
      end
    else
      if @chapter
        [[@chapter.name, @chapter], "Elections"]
      else
        [["Elections", nil]]
      end
    end
  end

end