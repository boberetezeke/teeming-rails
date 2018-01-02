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

  class AnswerTallyer
    attr_reader :choice_tallies, :round
    def initialize(last_answer_tallyer)
      if last_answer_tallyer
        initialize_from_last_answer_tallyer(last_answer_tallyer)
      else
        @choice_tallies = {}
        @round = 1
      end
    end

    def initialize_from_last_answer_tallyer(last_answer_tallyer)
      @round = last_answer_tallyer.round + 1
      sorted_choice_tallies = last_answer_tallyer.choice_tallies.values.sort_by{ |choice_tally| choice_tally.count }
      @choice_tallies = Hash[sorted_choice_tallies[1..-1].map do |ct|
        new_ct = ct.dup
        new_ct.round = @round
        new_ct.save

        [new_ct.value.to_i, new_ct]
      end]
      @exhausted_choice_tally = ChoiceTally.new(round: @round, value: nil)

      redistribute_choice_tally(sorted_choice_tallies.first)
      puts "got here"
    end

    def redistribute_choice_tally(choice_tally)
      choice_tally.choice_tally_answers.each do |cta|
        choice_number = 2
        choices = cta.answer.text.split(/:::/)
        found = false

        while choice_number < choices.size
          value = choices.index(choice_number.to_s) + 1
          if new_choice_tally = @choice_tallies[value]
            cta.update(choice_tally: new_choice_tally)
            new_choice_tally.update(count: new_choice_tally.count + 1)
            found = true
            break
          end
          choice_number += 1
        end
        cta.update(choice_tally: @exhausted_choice_tally) unless found
      end
    end

    def above_threshold(threshold_value)
      counts = @choice_tallies.values.map { |choice_tally| choice_tally.count }.sort.reverse
      (counts.first.to_f  / counts.sum.to_f) >= threshold_value
    end

    def count_value(value, answer)
      choice_tally = @choice_tallies[value]
      if choice_tally
        choice_tally.count += 1
        choice_tally.save
      else
        choice_tally = ChoiceTally.create(count: 1, value: value, question: answer.question, round: @round)
        @choice_tallies[value] = choice_tally
      end
      ChoiceTallyAnswer.create(choice_tally: choice_tally, answer: answer)
    end
  end

  def tally_answers
    questionnaire.questionnaire_sections.each do |questionnaire_section|
      questionnaire_section.questions.each do |question|
        tally_question_answers_all_rounds(question)
      end
    end
  end

  def tally_question_answers_all_rounds(question)
    if question.ranked_choice?
      round = 1
      answer_tallyer = nil
      loop do
        answer_tallyer = tally_question_answers(question, last_round_answer_tallyer: answer_tallyer)
        break if answer_tallyer.above_threshold(0.5)
      end
    else
      tally_question_answers(question)
    end
  end

  def tally_question_answers(question, last_round_answer_tallyer: nil)
    answer_tallyer = AnswerTallyer.new(last_round_answer_tallyer)
    if answer_tallyer.round == 1
      question.answers.each do |answer|
        if question.ranked_choice?
          value = answer.text.split(/:::/).index("1") + 1
          answer_tallyer.count_value(value, answer)
        elsif question.multiple_choice?
          answer.text.split(/:::/).each do |choice|
            answer_tallyer.count_value(choice, answer)
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