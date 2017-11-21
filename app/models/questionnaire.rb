class Questionnaire < ApplicationRecord
  # belongs_to :race
  belongs_to :questionnairable, polymorphic: true
  has_many :questionnaire_sections, dependent: :destroy

  scope :with_name, ->{ where(arel_table[:name].not_eq(nil)) }
  scope :with_race, ->{ where(questionnairable_type: 'Race') }

  def new_answers(user: nil)
    questionnaire_sections.map{|qs| qs.questions.to_a}.flatten.map.with_index{|q, index| q.new_answer(index: index, user: user)}
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
end