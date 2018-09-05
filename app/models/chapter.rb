class Chapter < ApplicationRecord
  CHAPTER_TYPE_AFFILIATE = 'affiliate'
  CHAPTER_TYPE_RECOGNIZED = 'recognized'
  CHAPTER_TYPE_INDEPENDENT = 'independent'

  CHAPTER_TYPES_HASH = {
     'Affiliate' => CHAPTER_TYPE_AFFILIATE,
     'Recognized' => CHAPTER_TYPE_RECOGNIZED,
     "Independent" => CHAPTER_TYPE_INDEPENDENT
  }

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

  def chapter_hash_for_profile

  end

  def self.collection_hash
    Hash[Chapter.all.map do |chapter|
      chapter.is_state_wide ?
        [chapter.name, chapter.id] :
        ["#{chapter.name} - (#{chapter.chapter_type_str})", chapter.id]
    end]
  end

  def chapter_type_str
    CHAPTER_TYPES_HASH.invert[chapter_type]
  end

  def affiliate?
    chapter_type == CHAPTER_TYPE_AFFILIATE
  end

  def active_officer_assignments
    officers.joins(:officer_assignments).merge(OfficerAssignment.active)
  end
end