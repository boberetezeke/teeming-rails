class VotesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @election = Election.find(params[:election_id])
    now = Time.zone.now

    if @election.offline_only?
      flash[:alert] = "only offline voting is allowed for this election"
      redirect_to root_path
    elsif current_user.is_disqualified_to_vote_in_election?(@election)
      redirect_to disqualified_election_votes_path(election_id: @election)
    else
      breadcrumbs votes_breadcrumbs, "Vote"

      @vote_completion = current_user.vote_completions.for_election(@election).first
      if now < @election.vote_start_time
        redirect_to wait_election_votes_path(election_id: @election)
      elsif now >= @election.vote_end_time
        if current_user.voted_in_election?(@election)
          redirect_to view_election_votes_path(election_id: @election)
        else
          redirect_to missed_election_votes_path(election_id: @election)
        end
      else
        @vote_completion.answers = @election.questionnaire.new_answers(user: current_user)
      end
    end
  end

  def view
    @election = Election.find(params[:election_id])
    if current_user.is_disqualified_to_vote_in_election?(@election)
      redirect_to disqualified_election_votes_path(election_id: @election)
    else
      authorize @election, :view_vote?

      @vote_completion = current_user.vote_completions.for_election(@election).first
      breadcrumbs votes_breadcrumbs, "View Votes"
    end
  end

  def create
    @election = Election.find(params[:election_id])

    if current_user.is_disqualified_to_vote_in_election?(@election)
      redirect_to disqualified_election_votes_path(election_id: @election)
    else
      breadcrumbs votes_breadcrumbs, "Vote"

      if params[:voter_email] || params[:ballot_identifier]
        authorize @election, :enter?

        new_vote_completion_args = {
            election: @election,
            vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_PAPER
        }

        if params[:voter_email]
          @voter_email = params[:voter_email]
          user = User.find_by_email(params[:voter_email])

          if user
            if vote_completion = user.voted_in_election?(@election)
              @voter_email_error = "voter has already voted (#{vote_completion.vote_type})"
            else
              @vote_completion = VoteCompletion.new(election: @election, user: user,
                                                    vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_PAPER)
            end
          else
            @voter_email_error = "email not found"
          end
        else
          @ballot_identifier = params[:ballot_identifier]
          ballot = @election.vote_completions.where(ballot_identifier: @ballot_identifier).first
          @ballot_identifier_error = "ballot already entered" if ballot
          new_vote_completion_args[:ballot_identifier] = @ballot_identifier
        end

        @vote_completion = VoteCompletion.new(new_vote_completion_args)

        params_answer_attributes = params['vote_completion']['answers_attributes']
        @vote_completion.answers_attributes = Answer.translate_choice_params(params_answer_attributes)

        if !(@voter_email_error || @ballot_identifier_error) && @vote_completion.save
          redirect_to enter_election_votes_path(@election)
        else
          Answer.translate_choice_text(@vote_completion.answers)
          render :enter
        end
      else
        authorize @election, :vote?

        now = Time.now.utc
        vote_error = nil
        if @election.vote_start_time <= now && now < @election.vote_end_time
          user = current_user
          @vote_completion = user.vote_completions.for_election(@election).first
          if @vote_completion
            if !@vote_completion.has_voted
              params_answer_attributes = params['vote_completion']['answers_attributes']
              Answer.translate_choice_params(params_answer_attributes)
              if @vote_completion.update(vote_completion_params(params))
                @vote_completion.update(has_voted: true)
                redirect_to view_election_votes_path(@election)
              else
                render :index
              end
            else
              vote_error = "you have already voted"
            end
          else
            vote_error = "you are not able to vote in this election"
          end
        else
          if now < @record.vote_start_time
            vote_error = "it is too early to vote"
          else
            vote_error = "it is too late to vote"
          end
        end

        if vote_error
          flash[:alert] = "You are unable to vote, because #{vote_error}"
          redirect_to root_path
        end
      end
    end

=begin
      if params[:votes]
        @votes = params[:votes].keys.map do |candidacy_id|
          Vote.new(candidacy: Candidacy.find(candidacy_id), user: user, election: @election)
        end
      else
        @votes = []
      end

      votes_valid, @overflow_districts = @election.votes_valid?(@votes)

      if votes_valid && user_valid
        @votes.each { |vote| vote.save }
        VoteCompletion.create(election: @election, user: user, has_voted: true, vote_type: vote_completion_type)

        if params[:voter_email]
          flash[:notice] = "The vote has been recorded"
          redirect_to enter_election_votes_path(@election)
        else
          flash[:notice] = "Your votes have been recorded"
          redirect_to view_election_votes_path(@election)
        end

      else
        if params[:voter_email]
          render 'enter'
        else
          render 'index'
        end
      end
    end
=end
  end

  def disqualified
    @election = Election.find(params[:election_id])
    authorize @election, :disqualified?

    @vote_completion = current_user.vote_completions.for_election(@election).disqualifications.first
  end

  def wait
    @election = Election.find(params[:election_id])
    authorize @election, :wait?
  end

  def missed
    @election = Election.find(params[:election_id])
    authorize @election, :missed?
  end

  def tallies
    @election = Election.find(params[:election_id])
    authorize @election, :tallies?

    # @tallies = @election.tally_votes
    if @election.questionnaire.choice_tallies.empty?
      @election.tally_answers
    end

    breadcrumbs votes_breadcrumbs, "Vote"
  end

  def enter
    @election = Election.find(params[:election_id])
    authorize @election, :enter?

    @vote_completion = VoteCompletion.new(election: @election, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE)
    @vote_completion.answers = @election.questionnaire.new_answers

    breadcrumbs votes_breadcrumbs, "Vote"
  end

  def delete_votes
    @election = Election.find(params[:election_id])
    authorize @election, :delete_votes?

    @election.votes.destroy_all
    @election.vote_completions.destroy_all

    redirect_to @election
  end

  def generate_tallies
    @election = Election.find(params[:election_id])
    authorize @election, :generate_tallies?

    @election.questionnaire.choice_tallies.destroy_all
    @election.tally_answers

    # @election.vote_tallies.destroy_all
    # @election.write_tallies

    redirect_to tallies_election_votes_path(@election)
  end

  def download_votes
    @election = Election.find(params[:election_id])
    authorize @election, :download_votes?

    csv = CSV.generate do |csv_gen|
      csv_gen << [
        "Candidate",
        "User Name",
        "User Email",
        "Vote Type"
      ]

      @election.votes.by_user.each do |vote|
        vote_completion = VoteCompletion.find_by(election: vote.election, user: vote.user)
        csv_gen << [
          vote.candidacy.name,
          vote.user.member.name,
          vote.user.email,
          vote_completion.vote_type
        ]
      end
    end

    send_data csv,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=votes-#{@election.name}.csv"
  end

  private

  def vote_completion_params(params)
    params.require(:vote_completion).permit(
      {
        answers_attributes: QuestionnairesController.permitted_answer_attributes
      }
    )
  end

  def votes_breadcrumbs(include_link: true)
    [@election.name, election_path(@election)]
  end
end