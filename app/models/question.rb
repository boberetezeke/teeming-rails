class Question < ApplicationRecord
  belongs_to :questionnaire

  def new_answer(candidacy=nil)
    Answer.new(candidacy: candidacy, question: self)
  end
end