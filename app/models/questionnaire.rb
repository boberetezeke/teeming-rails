class Questionnaire < ApplicationRecord
  # belongs_to :race
  belongs_to :questionnairable, polymorphic: true
  has_many :questionnaire_sections, dependent: :destroy

  def new_answers(user: nil)
    questionnaire_sections.map{|qs| qs.questions.to_a}.flatten.map.with_index{|q, index| q.new_answer(index: index, user: user)}
  end
end