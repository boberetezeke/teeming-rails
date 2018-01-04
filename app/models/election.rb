class Election < ApplicationRecord
  belongs_to :chapter
  belongs_to :member_group

  has_many :races, dependent: :destroy
  accepts_nested_attributes_for :races

  has_many :issues, dependent: :destroy
  accepts_nested_attributes_for :issues

  has_many :vote_completions, dependent: :destroy
  # has_many :vote_tallies, dependent: :destroy

  has_one :questionnaire, as: :questionnairable
  has_many :messages, dependent: :destroy

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

  attr_accessor :vote_date_str
  attr_accessor :vote_start_time_str, :vote_end_time_str

  validates :name, presence: true
  validate :dates_and_times_are_valid

  def set_accessors
    self.vote_date_str = self.vote_date.strftime("%m/%d/%Y")          if self.vote_date
    self.vote_start_time_str = self.vote_start_time.strftime("%H:%M") if self.vote_start_time
    self.vote_end_time_str = self.vote_end_time.strftime("%H:%M")     if self.vote_end_time
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
      if question.answers.present?
        loop do
          answer_tallyer = tally_question_answers(question, last_round_answer_tallyer: answer_tallyer, questionnaire: questionnaire)
          break if answer_tallyer.above_threshold(0.5)
        end
      end
    else
      tally_question_answers(question, questionnaire: questionnaire)
    end
  end

  def tally_question_answers(question, last_round_answer_tallyer: nil, questionnaire: nil)
    answer_tallyer = AnswerTallyer.new(last_round_answer_tallyer, questionnaire: questionnaire)
    if answer_tallyer.round == 1
      question.answers.each do |answer|
        if question.ranked_choice?
          value = answer.text.split(/:::/).index("1") + 1
          answer_tallyer.count_value(value, answer)
        elsif question.multiple_choice?
          answer.text.split(/:::/).each do |choice|
            answer_tallyer.count_value(choice, answer) if choice.present?
          end
        else
          answer_tallyer.count_value(answer.text, answer)
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