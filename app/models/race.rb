class Race < ApplicationRecord
  belongs_to :account

  belongs_to :election
  has_many :candidacies, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :vote_tallies, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_one   :questionnaire,          ->{ where(use_type: 'candidacy') }, as: :questionnairable
  has_one   :election_questionnaire, ->{ where(use_type: 'election') },  as: :questionnairable, class_name: 'Questionnaire'

  belongs_to  :created_by_user, class_name: 'User', foreign_key: 'created_by_user_id'
  belongs_to  :updated_by_user, class_name: 'User', foreign_key: 'updated_by_user_id'
  belongs_to  :chapter

  validates :name, presence: true,                if: ->{ election.internal? }
  validates :level_of_government, presence: true, if: ->{ election.external? }
  validates :locale, presence: true,              if: ->{ election.external? }

  validate :dates_are_valid

  scope :active_for_time, ->(time)    { where(Race.arel_table[:filing_deadline_date].gt(time) ) }
  scope :by_last_update,  ->          {  order("updated_at desc") }
  scope :for_chapter,     ->(chapter) { chapter ? where(chapter_id: chapter.id) : where("true") }

  attr_accessor :filing_deadline_date_str
  attr_accessor :candidates_announcement_date_str

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
  LEVEL_OF_GOVERNMENT_TYPE_ATTORNEY_GENERAL =       'attorney_general'
  LEVEL_OF_GOVERNMENT_TYPE_SUPREME_COURT_JUDGE =    'supreme_court_judge'
  LEVEL_OF_GOVERNMENT_TYPE_APPELLATE_COURT_JUDGE =  'appellate_court_judge'
  LEVEL_OF_GOVERNMENT_TYPE_LOCAL_JUDGE =            'local_judge'
  LEVEL_OF_GOVERNMENT_TYPE_PARK_COMMISSIONER =      'park_commissioner'

  LEVEL_OF_GOVERNMENT_TYPES = {
      "School Board" =>          LEVEL_OF_GOVERNMENT_TYPE_SCHOOL_BOARD,
      "Mayor" =>                 LEVEL_OF_GOVERNMENT_TYPE_MAYOR,
      "City Council" =>          LEVEL_OF_GOVERNMENT_TYPE_CITY_COUNCIL,
      "County Commissioner" =>   LEVEL_OF_GOVERNMENT_TYPE_COUNTY_COMMISSIONER,
      "County Prosecutor" =>     LEVEL_OF_GOVERNMENT_TYPE_COUNTY_PROSECUTOR,
      "Sheriff" =>               LEVEL_OF_GOVERNMENT_TYPE_SHERIFF,
      "State Representative" =>  LEVEL_OF_GOVERNMENT_TYPE_STATE_REPRESENTATIVE,
      "State Senator" =>         LEVEL_OF_GOVERNMENT_TYPE_STATE_SENATOR,
      "State Auditor" =>         LEVEL_OF_GOVERNMENT_TYPE_STATE_AUDITOR,
      "Secretary of State" =>    LEVEL_OF_GOVERNMENT_TYPE_SECRETARY_OF_STATE,
      "Governor" =>              LEVEL_OF_GOVERNMENT_TYPE_GOVERNOR,
      "U.S. Congressperson" =>   LEVEL_OF_GOVERNMENT_TYPE_CONGRESSPERSON,
      "U.S. Senator" =>          LEVEL_OF_GOVERNMENT_TYPE_SENATOR,
      "Attorney General" =>      LEVEL_OF_GOVERNMENT_TYPE_ATTORNEY_GENERAL,
      "Supreme Court Judge" =>   LEVEL_OF_GOVERNMENT_TYPE_SUPREME_COURT_JUDGE,
      "Appellate Court Judge" => LEVEL_OF_GOVERNMENT_TYPE_APPELLATE_COURT_JUDGE,
      "Local Judge" =>           LEVEL_OF_GOVERNMENT_TYPE_LOCAL_JUDGE,
      "Park Commissioner" =>     LEVEL_OF_GOVERNMENT_TYPE_PARK_COMMISSIONER
  }

  def set_accessors
    self.filing_deadline_date_str = self.filing_deadline_date.strftime("%m/%d/%Y")                  if self.filing_deadline_date
    self.candidates_announcement_date_str = self.candidates_announcement_date.strftime("%m/%d/%Y")  if self.candidates_announcement_date
  end

  def candidates_announced?
    false
    #candidates_announcement_date &&
    #   candidates_announcement_date < Time.now
  end

  def type_and_locale
    "#{locale} #{LEVEL_OF_GOVERNMENT_TYPES.invert[level_of_government]}" +
        (is_official ? " (Official)" : "")
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

  def dates_are_valid
    if election.internal?
      valid_filing_deadline_date = validate_date(:filing_deadline_date)
      valid_candidates_announcemnt_date = validate_date(:candidates_announcement_date)
      if valid_filing_deadline_date && valid_candidates_announcemnt_date
        if self.filing_deadline_date > self.candidates_announcement_date
          errors.add(:base, "filing date must be at or before candidates announcement date")
        end

        if self.filing_deadline_date > self.election.vote_date
          errors.add(:base, "filing date must be before the vote date")
        end

        if self.candidates_announcement_date > self.election.vote_date
          errors.add(:base, "candidate announcement date must be before the vote date")
        end
      end
    end
  end
end
