class Member < ApplicationRecord
  # validates :databank_id, presence: true, uniqueness: true
  belongs_to :user
  accepts_nested_attributes_for :user

  belongs_to :chapter
  belongs_to :potential_chapter, foreign_key: :potential_chapter_id, class_name: "Chapter"

  has_many :member_group_memberships
  has_many :member_groups, through: :member_group_memberships

  has_many :officer_assignments
  has_many :officers, through: :officer_assignments

  has_many :answers, as: :answerable
  accepts_nested_attributes_for :answers

  has_many :message_controls, dependent: :destroy
  accepts_nested_attributes_for :message_controls

  has_many :message_recipients, dependent: :destroy

  attr_accessor :with_user_input

  validates :first_name, :last_name, presence: true, if: ->{ with_user_input }
  validates :address_1, presence: true,              if: ->{ with_user_input }
  validates :city, presence: true,                   if: ->{ with_user_input }
  validates :state, presence: true,                  if: ->{ with_user_input }
  validates :zip, presence: true,                    if: ->{ with_user_input }

  SCOPE_TYPES = {
    interested_in_volunteering:   "Interested in Volunteering",
    potential_chapter_members:    "Potential Chapter Members",
    chapter_members:              "Chapter Members",
    officers:                     "Officers",
    executive_committee_members:  "Executive Committee Members"
  }

  scope :officers,                    ->(chapter) { where('(true)') }
  scope :executive_committee_members, ->(chapter) { where('(true)') }

  scope :interested_in_volunteering,        ->(chapter) {
    joins(:user).where(User.arel_table[:interested_in_volunteering].eq(true))
  }

  scope :potential_chapter_members, ->(chapter) {
    where(Member.arel_table[:potential_chapter_id].eq(chapter.id).and(
      Member.arel_table[:chapter_id].eq(Chapter.find_by_is_state_wide(true).id)
    ))
  }
  scope :chapter_members,     ->(chapter) { where(chapter_id: chapter.id) }
  # scope :chapter_members, ->(chapter) { where(Member.arel_table[:chapter_id].not_eq(nil)) }

  scope :valid_email, -> {
    where(
      '(status != ? AND status != ? AND status != ? AND status != ?)',
      'invalid', 'bounce', 'block', 'unsubscribe'
    )
  }

  scope :active, -> {
    where(status: 'active')
  }

  def name
    "#{first_name} #{last_name}"
  end

  def message_control_for(unsubscribe_type)
    message_controls.where(unsubscribe_type: unsubscribe_type).first
  end

  def can_recieve_message_for?(message_type)
    return true if message_type == Message::MESSAGE_TYPE_CANDIDACY || message_type == Message::MESSAGE_TYPE_ELECTION

    message_control_for(unsubscribe_type).control_type != MessageControl::CONTROL_TYPE_UNSUBSCRIBE
  end
end
