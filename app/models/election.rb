class Election < ApplicationRecord
  belongs_to :account

  # belongs_to :chapter
  belongs_to :member_group

  has_many :races, dependent: :destroy
  accepts_nested_attributes_for :races

  has_many :issues, dependent: :destroy
  accepts_nested_attributes_for :issues

  has_many :vote_completions, dependent: :destroy
  # has_many :vote_tallies, dependent: :destroy

  has_one :questionnaire, as: :questionnairable
  has_many :messages, dependent: :destroy

  scope :show_on_dashboard, ->(chapter) {
    where(
      arel_table[:election_type].eq(ELECTION_TYPE_EXTERNAL).or(
          chapter ? arel_table[:member_group_id].eq(chapter.id) : Arel::Nodes::True.new
      )
    )
  }

  scope :visible, ->(chapter) {
    where(
      (chapter ?
           arel_table[:visibility].in([Visibility::VISIBILITY_SHOW_CHAPTER, Visibility::VISIBILITY_SHOW_ALL])
           :
           arel_table[:visibility].eq(Visibility::VISIBILITY_SHOW_ALL)
      )
    )
  }

  scope :for_chapter, ->(chapter) {
    where(chapter ? arel_table[:member_group_id].eq(chapter.id) : Arel::Nodes::True.new)
  }

  ELECTION_TYPE_INTERNAL = 'internal'
  ELECTION_TYPE_EXTERNAL = 'external'

  ELECTION_METHOD_ONLINE_ONLY =         'online_only'
  ELECTION_METHOD_ONLINE_AND_OFFLINE =  'online_and_offline'
  ELECTION_METHOD_OFFLINE_ONLY =        'offline_only'

  ELECTION_METHODS = {
      "Online only" =>                  ELECTION_METHOD_ONLINE_ONLY,
      "Online and Offline" =>           ELECTION_METHOD_ONLINE_AND_OFFLINE,
      "Offline only (secret ballot)" => ELECTION_METHOD_OFFLINE_ONLY
  }

  scope :internal, ->{ where(election_type: ELECTION_TYPE_INTERNAL) }
  scope :external, ->{ where(election_type: ELECTION_TYPE_EXTERNAL) }
  scope :by_election_type, ->{ order('election_type asc') }
  scope :by_most_recent,   ->{ order("vote_date desc") }
  scope :before_date, ->(date){ where(arel_table[:vote_date].lt(date)) }

  attr_accessor :vote_date_str
  attr_accessor :vote_start_time_str, :vote_end_time_str

  validates :name, presence: true
  validate :dates_and_times_are_valid

  def set_accessors
    self.vote_date_str = self.vote_date.strftime("%m/%d/%Y")          if self.vote_date
    self.vote_start_time_str = self.vote_start_time.strftime("%I:%M%P") if self.vote_start_time
    self.vote_end_time_str = self.vote_end_time.strftime("%I:%M%P")     if self.vote_end_time
  end

  def external?
    election_type == ELECTION_TYPE_EXTERNAL
  end

  def internal?
    election_type == ELECTION_TYPE_INTERNAL
  end

  def online_only?
    election_method == ELECTION_METHOD_ONLINE_ONLY
  end

  def online?
    election_method == ELECTION_METHOD_ONLINE_AND_OFFLINE || election_method == ELECTION_METHOD_ONLINE_ONLY
  end

  def offline_only?
    election_method == ELECTION_METHOD_OFFLINE_ONLY
  end

  def offline?
    election_method == ELECTION_METHOD_ONLINE_AND_OFFLINE || election_method == ELECTION_METHOD_OFFLINE_ONLY
  end

  def is_frozen?
    is_frozen
  end

  def freeze_election
    update(is_frozen: true)

    voters.each do |member|
      user = member.user
      if user
        VoteCompletion.create(election: self, user: user, vote_type: VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE)
      end
    end

    self.questionnaire = Questionnaire.new
    self.issues.each do |issue|
      self.questionnaire.append_questionnaire_sections(issue.questionnaire)
    end
    self.races.each do |race|
      self.questionnaire.append_questionnaire_sections(race.election_questionnaire)
    end
  end

  def unfreeze_election
    update(is_frozen: false)
    vote_completions.destroy_all
    questionnaire.destroy
  end

  def voters
    member_group.all_members(chapter)
  end

  def tally_answers
    questionnaire.questionnaire_sections.each do |questionnaire_section|
      questionnaire_section.questions.each do |question|
        tally_question_answers_all_rounds(question, questionnaire)
      end
    end
  end

  def tally_question_answers_all_rounds(question, questionnaire)
    if question.ranked_choice?
      round = 1
      answer_tallyer = nil
      if question.answers.filled_in.present?
        loop do
          answer_tallyer = tally_question_answers(question, last_round_answer_tallyer: answer_tallyer, questionnaire: questionnaire)
          break if answer_tallyer.above_threshold(0.5) || answer_tallyer.empty?
        end
      end
    else
      tally_question_answers(question, questionnaire: questionnaire)
    end
  end

  def tally_question_answers(question, last_round_answer_tallyer: nil, questionnaire: nil)
    answer_tallyer = AnswerTallyer.new(last_round_answer_tallyer, questionnaire: questionnaire)
    if answer_tallyer.round == 1
      # joins(:vote_completion).where(VoteCompletion.arel_table[:vote_type].in(['online', 'disqualified']))
      question.answers.filled_in.each do |answer|
        if answer.answerable && !answer.answerable.disqualified?
          if question.ranked_choice?
            first_vote = answer.text.split(/:::/).index("0")
            if first_vote
              value = first_vote  + 1
              answer_tallyer.count_value(value, answer)
            end
          elsif question.multiple_choice?
            answer.text.split(/:::/).each do |choice|
              answer_tallyer.count_value(choice, answer) if choice.present?
            end
          else
            answer_tallyer.count_value(answer.text, answer)
          end
        end
      end
    end

    answer_tallyer
  end

  def tally_votes
    if races.present?
      races.first.tally_votes
    else
      {}
    end
  end

  def write_tallies
    races.first.write_tallies if races.present?
  end

  def generate_votes_csv(is_anonymous: false)
    csv = CSV.generate do |csv_gen|
      if is_anonymous
        columns =  ["Disqualified"]
      else
        columns = [
          "User Name",
          "User Email",
        ]
      end

      column_indexes = {}
      questions = {}
      column_index = columns.size
      self.questionnaire.questionnaire_sections.each do |questionnaire_section|
        columns << questionnaire_section.title
        column_index += 1
        questionnaire_section.questions.each do |question|
          columns << question.text
          column_index += 1
          column_indexes[question.id] = column_index
          questions[question.id] = question
          if question.has_choices?
            question.choices.each do |choice|
              columns << choice.title
              column_index += 1
            end
          end
        end
      end

      csv_gen << columns
      row_size = columns.size

      self.vote_completions.completed.each do |vote_completion|
        columns = Array.new(row_size) { "" }
        if is_anonymous
          columns[0] = vote_completion.disqualified? ? "X" : ""
        else
          columns[0] = vote_completion.user.name
          columns[1] = vote_completion.user.email
        end

        vote_completion.answers.each do |answer|
          column_index = column_indexes[answer.question_id]
          question = questions[answer.question_id]
          if question.has_choices?
            answer.text.split(/:::/).each_with_index do |value, index|
              columns[column_index + index] = value
            end
          else
            columns[column_index] = answer.text
          end
        end

        csv_gen << columns
      end
    end

    csv
  end

  def dates_and_times_are_valid
    valid_date = validate_date(:vote_date)
    valid_start_time = validate_time(:vote_start_time)
    valid_end_time = validate_time(:vote_end_time)

    if valid_date && valid_start_time && valid_end_time
      return if vote_start_time.blank? && vote_end_time.blank?
      if vote_start_time.present? && vote_end_time.present?
        if vote_start_time > vote_end_time
          errors.add(:base, "the start time should be before the end time")
        else
          self.vote_start_time = self.vote_start_time.change(year: vote_date.year, month: vote_date.month, day: vote_date.day)
          self.vote_end_time =   self.vote_end_time.change(  year: vote_date.year, month: vote_date.month, day: vote_date.day)
        end
      else
        errors.add(:base, "both start and end times (or neither) must be present")
      end
    end
  end

end
