class Question < ApplicationRecord
  belongs_to :questionnaire_section
  has_many   :choices, dependent: :destroy
  has_many   :answers, dependent: :destroy

  QUESTION_TYPE_SHORT_TEXT =      'short_text'
  QUESTION_TYPE_LONG_TEXT =       'long_text'
  QUESTION_TYPE_MULTIPLE_CHOICE = 'multiple_choice'
  QUESTION_TYPE_CHECKBOXES =      'checkboxes'

  default_scope ->{ order('order_index asc') }

  def new_answer(candidacy: nil, index: nil)
    Answer.new(candidacy: candidacy, question: self, order_index: index)
  end
end