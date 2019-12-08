class QuestionnaireSection < ApplicationRecord
  belongs_to :account

  belongs_to :questionnaire
  has_many :questions, dependent: :destroy

  validates :title, presence: true

  default_scope ->{ order('order_index asc') }

  def copy(order_index: nil)
    new_questionnaire_section = self.dup
    new_questionnaire_section.order_index = order_index if order_index
    new_questionnaire_section.save
    self.questions.each do |question|
      new_questionnaire_section.questions << question.copy
    end

    new_questionnaire_section
  end
end