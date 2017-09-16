class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  ROLE_TYPE_USER = :user
  ROLE_TYPE_ADMIN = :admin
  ROLE_TYPES = [ROLE_TYPE_USER, ROLE_TYPE_ADMIN]

  has_many :event_rsvps
  accepts_nested_attributes_for :event_rsvps

  has_many :events, through: :event_rsvps

  has_many :candidacies
  accepts_nested_attributes_for :candidacies

  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  has_one  :member, dependent: :destroy
  accepts_nested_attributes_for :member

  has_many :votes
  has_many :vote_completions

  belongs_to :role

  before_save :setup_wizard

  def new_candidacy(race)
    Candidacy.new(user: self, race: race)
  end

  def admin?
    role == ROLE_TYPE_ADMIN
  end

  def accepted_bylaws
    self.accepted_bylaws_at.present?
  end

  def accepted_bylaws=(accepted)
    if accepted
      self.accepted_bylaws_at = Time.now
    else
      self.accepted_bylaws_at = nil
    end
  end

  def in_race?(race)
    candidacies.map(&:race).include?(race)
  end

  def is_disqualified_to_vote_in_race?(race)
    vote_completions.for_race(race).disqualifications.first
  end

  def voted_in_race?(race)
    vote_completions.for_race(race).completed.first
  end

  def method_missing(sym, *args, &block)
    if sym.to_s =~ /^can_/
      if role && role.respond_to?(sym)
        role.send(sym)
      end
    end
  end

  private

  def setup_wizard
    self.setup_state = 'step_setup_user_details' unless self.persisted?
  end
end

