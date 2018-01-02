class Questionnaire < ApplicationRecord
  # belongs_to :race
  belongs_to :questionnairable, polymorphic: true
  has_many :questionnaire_sections, dependent: :destroy
  has_many :choice_tallies

  scope :with_name, ->{ where(arel_table[:name].not_eq(nil)) }
  scope :with_race, ->{ where(questionnairable_type: 'Race') }

  def new_answers(user: nil)
    answers = questionnaire_sections.map{|qs| qs.questions.to_a}.flatten.map.with_index{|q, index| q.new_answer(index: index, user: user)}
    Answer.translate_choice_text(answers)
  end

  def tally_choices
    questionnaire_sections.each do |questionnaire_section|
      questionnaire_section.questions.each do |question|
        question.tally_choices
      end
    end
  end

  def name
    if questionnairable_type == "Race"
      if questionnairable
        questionnairable.complete_name
      else
        nil
      end
    else
      read_attribute(:name)
    end
  end

  def copy
    if read_attribute(:name).present?
      name = "Copy of " + read_attribute(:name)
    else
      name = nil
    end

    new_questionnaire = self.dup
    new_questionnaire.save
    self.questionnaire_sections.each do |questionnaire_section|
      new_questionnaire.questionnaire_sections << questionnaire_section.copy
    end

    new_questionnaire
  end

  def max_order_index
    last_section = questionnaire_sections.last
    if last_section
      last_section.order_index
    else
      0
    end
  end

  def append_questionnaire_sections(questionnaire)
    order_index = max_order_index + 1
    questionnaire.questionnaire_sections.each do |questionnaire_section|
      self.questionnaire_sections << questionnaire_section.copy(order_index: order_index)
      order_index += 1
    end
  end
end