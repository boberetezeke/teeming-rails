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

  def choices_text
    return [] unless text.present?

    choices_hash = Hash[question.choices.map{|c| [c.value, c.title]}]
    text.split(/ /).reject{|c| c.blank? }.map do |choice_value|
      choices_hash[choice_value]
    end
  end
end