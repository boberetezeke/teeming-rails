class Member < ApplicationRecord
  # validates :databank_id, presence: true, uniqueness: true
  belongs_to :user
  accepts_nested_attributes_for :user

  belongs_to :chapter
  belongs_to :potential_chapter, foreign_key: :potential_chapter_id, class_name: "Chapter"

  has_many :member_group_memberships
  has_many :member_groups, through: :member_group_memberships

  has_many :answers, as: :answerable
  accepts_nested_attributes_for :answers

  has_many :message_controls, dependent: :destroy
  accepts_nested_attributes_for :message_controls

  has_many :message_recipients, dependent: :destroy

  attr_accessor :with_user_input

  validates :email, :uniqueness => true
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
    board_members:                "Board Members",
    executive_committee_members:  "Executive Committee Members"
  }

  MEMBER_ATTRS_ALL =           'all'
  MEMBER_ATTRS_VOLUNTEER =     'volunteer'
  MEMBER_ATTRS_START_CHAPTER = 'start-chapter'

  MEMBER_TYPE_ALL =       'all'
  MEMBER_TYPE_MEMBER =    'member'
  MEMBER_TYPE_POTENTIAL = 'potential'

  scope :officers,                    ->(chapter) { joins(user: :officers) }
  scope :board_members,               ->(chapter) { officers.where(is_board_member: true) }
  scope :executive_committee_members, ->(chapter) { officers.where(is_executive_committee_member: true) }

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
  scope :all_chapter_members, ->(chapter) {
    where(
      Member.arel_table[:chapter_id].eq(chapter.id).or(
        Member.arel_table[:potential_chapter_id].eq(chapter.id).and(
          Member.arel_table[:chapter_id].eq(Chapter.find_by_is_state_wide(true).id)
        )
      )
    )
  }

  scope :valid_email, -> {
    where(
      '(status != ? AND status != ? AND status != ? AND status != ?)',
      'invalid', 'bounce', 'block', 'unsubscribe'
    )
  }
  scope :filtered_by_string, ->(search) { where("lower((first_name || ' ' || last_name || ' ' || members.email)) like lower('%#{connection.quote(search)[1..-2]}%')") }
  scope :filtered_by_attrs, ->(member_type) {
    if member_type == Member::MEMBER_ATTRS_VOLUNTEER
      where(User.arel_table[:interested_in_volunteering].eq(true))
    elsif member_type == Member::MEMBER_ATTRS_START_CHAPTER
      where(Member.arel_table[:interested_in_starting_chapter].eq(true))
    else
      where("true")
    end
  }

  scope :active, -> {
    where(status: 'active')
  }

  MEMBER_FILTERS = {
    search:       '',
    member_type:  MEMBER_TYPE_ALL,
    attr_type:    MEMBER_ATTRS_ALL
  }


  MEMBER_TYPES_HASH = {
      "All" =>              MEMBER_TYPE_ALL,
      "Member" =>           MEMBER_TYPE_MEMBER,
      "Potential member" => MEMBER_TYPE_POTENTIAL
  }

  MEMBER_ATTRS_HASH = {
      "All" =>                    MEMBER_ATTRS_ALL,
      "Wants to volunteer" =>     MEMBER_ATTRS_VOLUNTEER,
      "Wants to start chapter" => MEMBER_ATTRS_START_CHAPTER
  }

  def name
    "#{first_name} #{last_name}"
  end

  def message_control_for(unsubscribe_type)
    message_controls.where(unsubscribe_type: unsubscribe_type).first
  end

  def share_name_with?(current_user)
    !user || (user && user.share_name_with?(current_user))
  end

  def share_email_with?(current_user)
    !user || (user && user.share_email_with?(current_user))
  end

  def share_phone_with?(current_user)
    !user || (user && user.share_phone_with?(current_user))
  end

  def share_address_with?(current_user)
    !user || (user && user.share_address_with?(current_user))
  end

  def can_receive_message_for?(medium_type, message_type)
    return true if message_type == Message::MESSAGE_TYPE_CANDIDACY || message_type == Message::MESSAGE_TYPE_ELECTION

    message_control = message_control_for(medium_type)
    !message_control || message_control.control_type != MessageControl::CONTROL_TYPE_UNSUBSCRIBE
  end
end
