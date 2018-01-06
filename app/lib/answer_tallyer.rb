class AnswerTallyer
  attr_reader :choice_tallies, :round
  def initialize(last_answer_tallyer, questionnaire: nil)
    @questionnaire = questionnaire
    if last_answer_tallyer
      initialize_from_last_answer_tallyer(last_answer_tallyer)
    else
      # File.open("tally-debug.txt", "w") { }
      @choice_tallies = {}
      @round = 1
      debug "-------- round: #{@round} -------------"
    end
  end

  def empty?
    @choice_tallies.empty?
  end

  def initialize_from_last_answer_tallyer(last_answer_tallyer)
    @round = last_answer_tallyer.round + 1
    debug "-------- round: #{@round} -------------"
    sorted_choice_tallies = last_answer_tallyer.choice_tallies.values.sort_by{ |choice_tally| choice_tally.count }
    @choice_tallies = Hash[sorted_choice_tallies[1..-1].map do |ct|
      new_ct = ct.dup
      new_ct.round = @round
      new_ct.choice_tally_answers = ct.choice_tally_answers.map{|cta| cta.dup}
      new_ct.save

      [new_ct.value.to_i, new_ct]
    end]
    @exhausted_choice_tally = ChoiceTally.new(round: @round, value: nil, count: 0, questionnaire: @questionnaire)

    tally_to_redistribute = sorted_choice_tallies.first
    debug "tally_to_redistribute: (#{tally_to_redistribute.value}), count: #{tally_to_redistribute.count}"
    redistribute_choice_tally(tally_to_redistribute)
  end

  def redistribute_choice_tally(choice_tally)
    choice_tally.choice_tally_answers.each do |cta|
      choice_number = 1
      choices = cta.answer.text.split(/:::/)
      # debug("choices to redistribute: #{choices}")
      found = false

      while choice_number < choices.size
        # find the position of the nth choice. that is the value
        index_of_choice = choices.index(choice_number.to_s)
        if index_of_choice
          value = index_of_choice + 1
          # debug("For choice_number: #{choice_number}, value = #{value}")
          if new_choice_tally = @choice_tallies[value]
            new_choice_tally.choice_tally_answers << cta.dup
            # cta.update(choice_tally: new_choice_tally)
            new_choice_tally.update(count: new_choice_tally.count + 1)
            debug("redistribute from (#{choice_tally.value}) to: (#{value}): #{@choice_tallies.values.map{|ct| [ct.value, ct.count]}}")
            found = true
            break
          else
            debug("ignoring value (#{value}) because candidate not found")
          end
          choice_number += 1
        else
          break
        end
      end

      unless found
        @exhausted_choice_tally.save unless @exhausted_choice_tally.persisted?
        @exhausted_choice_tally.choice_tally_answers << cta.dup
        @exhausted_choice_tally.update(count: @exhausted_choice_tally.count + 1, question: cta.answer.question)
        debug("redistribute to exhausted: round: #{@exhausted_choice_tally.round} count: #{@exhausted_choice_tally.count}")
      end
    end
  end

  def above_threshold(threshold_value)
    counts = @choice_tallies.values.map { |choice_tally| choice_tally.count }.sort.reverse
    debug "counts = #{counts}"
    (counts.first.to_f  / counts.sum.to_f) >= threshold_value
  end

  def count_value(value, answer)
    choice_tally = @choice_tallies[value]
    if choice_tally
      choice_tally.count += 1
      choice_tally.save
    else
      choice_tally = ChoiceTally.create(count: 1, value: value, question: answer.question, round: @round, questionnaire: @questionnaire)
      @choice_tallies[value] = choice_tally
    end
    # debug "answer: #{answer.text}"
    debug "choice_tallies(#{value}): #{@choice_tallies.values.map{|ct| [ct.value, ct.count]}}"
    ChoiceTallyAnswer.create(choice_tally: choice_tally, answer: answer)
  end

  def debug(str)
    # File.open("tally-debug.txt", "a") { |f| f.puts str }
    # puts str
    Rails.logger.debug "AnswerTallyer: #{str}"
  end
end
