class Chapter < ApplicationRecord
  has_many :elections
  has_many :members

  scope :local_chapters, ->{ where(is_state_wide: false) }
end