class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  ROLE_TYPE_USER = :user
  ROLE_TYPE_ADMIN = :admin
  ROLE_TYPES = [ROLE_TYPE_USER, ROLE_TYPE_ADMIN]

  has_many :candidacies

  attr_accessor :run_for_state_board

  before_save :setup_wizard

  def new_candidacy
    Candidacy.new(user: self)
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

  private

  def setup_wizard
    self.setup_state = 'step_setup_user_details' unless self.persisted?
  end
end

