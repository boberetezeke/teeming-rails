class Election < ApplicationRecord
  belongs_to :chapter
  has_many :races, dependent: :destroy
end