class QuestionnaireSection < ApplicationRecord
  belongs_to :questionnaire
  has_many :questions, dependent: :destroy

  validates :title, presence: true

  default_scope ->{ order('order_index asc') }
end