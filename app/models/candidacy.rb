class Candidacy < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :race, touch: true

  accepts_nested_attributes_for :answers

  PARTY_AFFILIATION_REPUBLICAN = 'republican'
  PARTY_AFFILIATION_DEMOCRAT = 'democrat'
  PARTY_AFFILIATION_GREEN = 'green'
  PARTY_AFFILIATION_DSA = 'dsa'
  PARTY_AFFILIATION_LIBERTARIAN = 'libertarian'
  PARTY_AFFILIATION_INDEPENDENCE_PARTY = 'independence_party'
  PARTY_AFFILIATION_OTHER = 'other'

  PARTY_AFFILATION_TYPES = {
      "Republican" =>                       PARTY_AFFILIATION_REPUBLICAN,
      "Democrat" =>                         PARTY_AFFILIATION_DEMOCRAT,
      "Green Party" =>                      PARTY_AFFILIATION_GREEN,
      "Democratic Socialists of America" => PARTY_AFFILIATION_DSA,
      "Libertarian" =>                      PARTY_AFFILIATION_LIBERTARIAN,
      "Indepdence Party" =>                 PARTY_AFFILIATION_INDEPENDENCE_PARTY,
      "Other" =>                            PARTY_AFFILIATION_OTHER
  }
end