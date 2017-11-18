class Issue < ApplicationRecord
  belongs_to :election
  belongs_to :chapter

  belongs_to  :created_by_user, class_name: 'User', foreign_key: 'created_by_user_id'
  belongs_to  :updated_by_user, class_name: 'User', foreign_key: 'updated_by_user_id'

  has_one :questionnaire, as: :questionnairable
  has_many :answers, as: :answerable
  accepts_nested_attributes_for :answers
end