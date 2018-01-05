class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :candidacy
  belongs_to :user
  belongs_to :answerable, polymorphic: true

  attr_accessor :text_checkboxes, :text_ranked_choices

  scope :filled_in, ->{ where(Answer.arel_table[:text].not_eq(nil)) }
  default_scope ->{ order('order_index asc') }

  # before_save :translate_text_checkboxes

  validate :text_ranked_choices_are_valid

  def text_ranked_choices_are_valid
    if question.ranked_choice? && text.present?
      text_ranked_choices = text.split(/:::/).reject{|choice| choice == "-"}
      if text_ranked_choices.map(&:to_i).sort != (0..(text_ranked_choices.size - 1)).to_a
        errors.add(:base, "ranked choices must be from 1 to the number of your choices")
      end
    end
  end

  def self.translate_choice_text(answers)
    answers.each do |answer|
      if answer && answer.text
        answer_entries = answer.text.split(/:::/).reject{|a| a.blank?}
      else
        answer_entries = []
      end

      if answer.question.question_type == Question::QUESTION_TYPE_CHECKBOXES
        answer.text_checkboxes = answer_entries
      elsif answer.question.question_type == Question::QUESTION_TYPE_RANKED_CHOICE
        answer.text_ranked_choices = answer_entries
      end
    end

    answers
  end

  def self.translate_choice_params(params)
    if params
      params.values.each do |answer_params|
        if answer_params['text_checkboxes'].is_a?(Array)
          answer_params['text'] = answer_params['text_checkboxes'].join(':::')
        end
        if answer_params['text_ranked_choices'].is_a?(Array)
          answer_params['text'] = answer_params['text_ranked_choices'].join(':::')
        end
      end
    end
  end

  def choices_text
    return [] unless text.present?

    choices_hash = Hash[question.choices.map{|c| [c.value, c.title]}]
    text.split(/:::/).reject{|c| c.blank? }.map do |choice_value|
      choices_hash[choice_value]
    end
  end
end