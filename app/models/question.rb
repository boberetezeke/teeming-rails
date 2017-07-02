class Question < ApplicationRecord
  belongs_to :questionnaire

  def new_answer(user)
    Answer.new(candidacy: user.new_candidacy, question: self)
  end
end