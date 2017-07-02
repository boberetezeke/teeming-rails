class Chapter < ApplicationRecord
  has_many :elections
  has_many :members
end