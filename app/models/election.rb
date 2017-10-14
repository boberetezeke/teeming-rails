class Election < ApplicationRecord
  belongs_to :chapter
  has_many :races, dependent: :destroy

  ELECTION_TYPE_INTERNAL = 'internal'
  ELECTION_TYPE_EXTERNAL = 'external'

  scope :internal, ->{ where(election_type: ELECTION_TYPE_INTERNAL) }
  scope :external, ->{ where(election_type: ELECTION_TYPE_EXTERNAL) }
  scope :by_election_type, ->{ order('election_type asc') }

  def external?
    election_type == ELECTION_TYPE_EXTERNAL
  end

  def internal?
    election_type == ELECTION_TYPE_INTERNAL
  end
end