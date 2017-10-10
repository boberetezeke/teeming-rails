class Race < ApplicationRecord
  belongs_to :election
  has_many :candidacies, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :vote_completions, dependent: :destroy
  has_many :vote_tallies, dependent: :destroy
  has_one  :questionnaire, as: :questionnairable
  belongs_to  :created_by_user, class_name: 'User', foreign_key: 'created_by_user_id'
  belongs_to  :updated_by_user, class_name: 'User', foreign_key: 'updated_by_user_id'

  validates :name, presence: true,                if: ->{ election.internal? }
  validates :level_of_government, presence: true, if: ->{ election.external? }
  validates :locale, presence: true,              if: ->{ election.external? }

  scope :active_for_time, ->(time){ where(Race.arel_table[:filing_deadline_date].gt(time) ) }
  scope :by_last_update, ->{  order("updated_at desc") }

  LEVEL_OF_GOVERNMENT_TYPE_SCHOOL_BOARD =           'school_board'
  LEVEL_OF_GOVERNMENT_TYPE_MAYOR =                  'mayor'
  LEVEL_OF_GOVERNMENT_TYPE_CITY_COUNCIL =           'city_council'
  LEVEL_OF_GOVERNMENT_TYPE_COUNTY_COMMISSIONER =    'county_commissioner'
  LEVEL_OF_GOVERNMENT_TYPE_COUNTY_PROSECUTOR =      'county_prosecutor'
  LEVEL_OF_GOVERNMENT_TYPE_SHERIFF =                'sheriff'
  LEVEL_OF_GOVERNMENT_TYPE_STATE_REPRESENTATIVE =   'state_representative'
  LEVEL_OF_GOVERNMENT_TYPE_STATE_SENATOR =          'state_senator'
  LEVEL_OF_GOVERNMENT_TYPE_STATE_AUDITOR =          'state_auditor'
  LEVEL_OF_GOVERNMENT_TYPE_SECRETARY_OF_STATE =     'secretary_of_state'
  LEVEL_OF_GOVERNMENT_TYPE_CONGRESSPERSON =         'congressperson'
  LEVEL_OF_GOVERNMENT_TYPE_SENATOR =                'senator'
  LEVEL_OF_GOVERNMENT_TYPE_GOVERNOR =               'govenor'

  LEVEL_OF_GOVERNMENT_TYPES = {
      "School Board" =>         LEVEL_OF_GOVERNMENT_TYPE_SCHOOL_BOARD,
      "Mayor" =>                LEVEL_OF_GOVERNMENT_TYPE_MAYOR,
      "City Council" =>         LEVEL_OF_GOVERNMENT_TYPE_CITY_COUNCIL,
      "County Commissioner" =>  LEVEL_OF_GOVERNMENT_TYPE_COUNTY_COMMISSIONER,
      "County Prosecutor" =>    LEVEL_OF_GOVERNMENT_TYPE_COUNTY_PROSECUTOR,
      "Sheriff" =>              LEVEL_OF_GOVERNMENT_TYPE_SHERIFF,
      "State Representative" => LEVEL_OF_GOVERNMENT_TYPE_STATE_REPRESENTATIVE,
      "State Senator" =>        LEVEL_OF_GOVERNMENT_TYPE_STATE_SENATOR,
      "State Auditor" =>        LEVEL_OF_GOVERNMENT_TYPE_STATE_AUDITOR,
      "Secretary of State" =>   LEVEL_OF_GOVERNMENT_TYPE_SECRETARY_OF_STATE,
      "Governor" =>             LEVEL_OF_GOVERNMENT_TYPE_GOVERNOR,
      "US. Congressperson" =>   LEVEL_OF_GOVERNMENT_TYPE_CONGRESSPERSON,
      "US. Senator" =>          LEVEL_OF_GOVERNMENT_TYPE_SENATOR
  }

  def candidates_announced?
    false
    #candidates_announcement_date &&
    #   candidates_announcement_date < Time.now
  end

  def type_and_locale
    "#{locale} #{LEVEL_OF_GOVERNMENT_TYPES.invert[level_of_government]}"
  end

  def complete_name
    if election.external?
      type_and_locale
    else
      name
    end
  end

  def before_filing_deadline?(utc_time)
    local_time = Time.zone.utc_to_local(utc_time)
    local_date = Date.new(local_time.year, local_time.month, local_time.day)
    local_date <= filing_deadline_date.utc.to_date
  end

  #
  # see also DistrictVoting.votes_valid?
  #
  def votes_valid?(votes)
    DistrictVoting.votes_valid?(votes)
  end

  def voting_rules
    DistrictVoting.voting_rules
  end

  #
  # tally the votes for this race
  #
  # @returns [Hash<Candidacy, Integer>] - a hash from candidacy and a count of votes
  #
  def tally_votes
    tallies = {}
    if vote_tallies.present?
      vote_tallies.each do |vote_tally|
        tallies[vote_tally.candidacy] = vote_tally.vote_count
      end
    else
      votes.each do |vote|
        candidacy = vote.candidacy
        tallies[candidacy] ||= 0
        tallies[candidacy] += 1
      end
    end

    tallies
  end

  def write_tallies
    tally_votes.each do |candidacy, count|
      VoteTally.create(race: self, candidacy: candidacy, vote_count: count)
    end
  end
end