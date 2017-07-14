class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :candidacy
  belongs_to :user

  attr_accessor :text_checkboxes

  default_scope ->{ order('order_index asc') }

  # before_save :translate_text_checkboxes

  def translate_text_checkboxes
    if question.question_type == Question::QUESTION_TYPE_CHECKBOXES
      self.text = self.text_checkboxes.join(" ")
    end
  end
end