class Chapter < ApplicationRecord
  has_many :elections, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :officers, dependent: :destroy
  has_many :meeting_minutes, dependent: :destroy

  has_one :skills_questionnaire, as: :questionnairable, class_name: 'Questionnaire'

  scope :local_chapters, ->{ where(is_state_wide: false) }

  def self.state_wide
    Chapter.find_by_is_state_wide(true)
  end
end