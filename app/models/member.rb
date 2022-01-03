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

  has_many :contact_attempts

  attr_accessor :with_user_input

  geocoded_by :address
  acts_as_taggable_on :districts, :subcaucuses, :sources, :general_tags

  validates :email, :uniqueness => true, allow_nil: true, unless: ->{ email.blank? && user.blank? }
  validates :first_name, :last_name, presence: true, if: ->{ with_user_input }
  validates :address_1, presence: true,              if: ->{ with_user_input }
  validates :city, presence: true,                   if: ->{ with_user_input }
  validates :state, presence: true,                  if: ->{ with_user_input }
  validates :zip, presence: true,                    if: ->{ with_user_input }

  DATABANK_EXPORT_COLUMNS = [
    "id",
    "databank_id", "address_1", "address_2", "city", "company", "email", "first_name", "home_phone", "last_name", "middle_initial",
    "mobile_phone", "state", "status", "work_phone", "zip", "created_at", "updated_at", "unsubscribe"
  ]
  DATABANK_COL_TO_INDEX = Hash[DATABANK_EXPORT_COLUMNS.map.with_index{|col, index| [col.to_sym, index]}]
  DATABANK_INDEX_TO_COL = DATABANK_COL_TO_INDEX.invert

  SCOPE_TYPES = {
    chapter_members:              "Chapter Members",
    chapter_users:                "Chapter Users",
    all_members:                  "All Members",
    all_users:                    "All Users",
    potential_chapter_members:    "Potential Chapter Members",
    interested_in_volunteering:   "Interested in Volunteering",
    officers:                     "Officers",
    board_members:                "Board Members",
    executive_committee_members:  "Executive Committee Members"
  }

  MEMBER_ATTRS_ALL =           'all'
  MEMBER_ATTRS_VOLUNTEER =     'volunteer'
  MEMBER_ATTRS_START_CHAPTER = 'start-chapter'

  MEMBER_TYPE_ALL =             'all'
  MEMBER_TYPE_MEMBER =          'member'
  MEMBER_TYPE_POTENTIAL =       'potential'
  MEMBER_TYPE_USER_MEMBER =     'user-member'
  MEMBER_TYPE_NON_MEMBER =      'non-member'
  MEMBER_TYPE_NON_USER_MEMBER = 'non-user-member'

  scope :officers,                    ->(chapter) {
    joins(user: :officers)
      .merge(Officer.active)
  }
  #.where(Member.arel_table[:chapter_id].eq(chapter.id))

  scope :board_members,               ->(chapter) {
    joins(user: :officers)
      .where(Officer.arel_table[:is_board_member].eq(true)
      )
      .merge(Officer.active)
  }
  # .and(
  #   Member.arel_table[:chapter_id].eq(chapter.id)
  # )

  scope :executive_committee_members, ->(chapter) {
    joins(user: :officers)
      .where(Officer.arel_table[:is_executive_committee_member].eq(true)
      )
      .merge(Officer.active)
  }
  # .and(
  #   Member.arel_table[:chapter_id].eq(chapter.id)
  # )

  scope :interested_in_volunteering,        ->(chapter) {
    joins(:user).where(User.arel_table[:interested_in_volunteering].eq(true))
  }

  scope :potential_chapter_members, ->(chapter) {
    where(Member.arel_table[:potential_chapter_id].eq(chapter.id))
    # where(Member.arel_table[:potential_chapter_id].eq(chapter.id).and(
    #   Member.arel_table[:chapter_id].eq(Chapter.find_by_is_state_wide(true).id)
    # ))
  }
  scope :chapter_members,     ->(chapter) { where(chapter_id: chapter.id) }
  scope :chapter_users,       ->(chapter) { joins(:user).where(chapter_id: chapter.id) }

  scope :all_chapter_members, ->(chapter) {
    where(
      Member.arel_table[:chapter_id].eq(chapter.id).or(
        Member.arel_table[:potential_chapter_id].eq(chapter.id)
      )
    )
    # where(
    #   Member.arel_table[:chapter_id].eq(chapter.id).or(
    #     Member.arel_table[:potential_chapter_id].eq(chapter.id).and(
    #       Member.arel_table[:chapter_id].eq(Chapter.find_by_is_state_wide(true).id)
    #     )
    #   )
    # )
  }

  scope :non_members_with_chapter, ->(chapter){ where(Member.arel_table[:is_non_member].eq(true).and(Member.arel_table[:potential_chapter_id].eq(chapter.id))) }
  scope :non_members, ->{ where(Member.arel_table[:is_non_member].eq(true)) }
  scope :non_user_members, ->{ where(Member.arel_table[:is_non_member].eq(nil).and(Member.arel_table[:user_id].eq(nil))) }
  scope :all_members, ->(chapter){ where(is_non_member: nil) }
  scope :all_users,   ->(chapter){ joins(:user) }

  scope :without_user, ->{ where(user_id: nil) }
  scope :with_user,    ->{ where(Member.arel_table[:user_id].not_eq(nil)) }

  scope :valid_email, -> {
    where(
      '(status != ? AND status != ? AND status != ? AND status != ?)',
      'invalid', 'bounce', 'block', 'unsubscribe'
    )
  }
  scope :tagged_by_string, ->(search, members) {
    if search.size >= 3
      tags = ActsAsTaggableOn::Tag.where("lower(name) like lower('%#{connection.quote(search)[1..-2]}%')")
      if tags.present?
        members.tagged_with(tags)
      else
        members
      end
    else
      members
    end
  }

  scope :filtered_by_string, ->(search) { where("lower(concat(first_name,  ' ', last_name, ' ', members.email, ' ', members.notes)) like lower('%#{connection.quote(search)[1..-2]}%')") }
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

  scope :sendable, -> {
    includes(:message_controls)
    .references(:message_controls)
    .where(MessageControl.arel_table[:control_type].eq(nil).or(
        MessageControl.arel_table[:control_type].not_eq(MessageControl::CONTROL_TYPE_UNSUBSCRIBE)
      )
    )
  }

  MEMBER_FILTERS = {
    search:       '',
    member_type:  MEMBER_TYPE_ALL,
    attr_type:    MEMBER_ATTRS_ALL,
    source:       "Any",
    subcaucus:    "Any",
    district:     "Any",
    general_tag:  "Any",
    restrict_by_chapter: true
  }


  MEMBER_TYPES_HASH = {
      "All" =>               MEMBER_TYPE_ALL,
      "User Members" =>      MEMBER_TYPE_USER_MEMBER,
      "Non Members" =>  MEMBER_TYPE_NON_MEMBER,
      "Potential User Members" => MEMBER_TYPE_POTENTIAL
  }

  MEMBER_TYPES_STATE_WIDE_HASH = {
      "All" =>              MEMBER_TYPE_ALL,
      "Members" =>          MEMBER_TYPE_MEMBER,
      "User Members" =>     MEMBER_TYPE_USER_MEMBER,
      "Non-User Members" => MEMBER_TYPE_NON_USER_MEMBER,
      "Non Members" =>      MEMBER_TYPE_NON_MEMBER,
  }

  MEMBER_ATTRS_HASH = {
      "All" =>                    MEMBER_ATTRS_ALL,
      "Wants to volunteer" =>     MEMBER_ATTRS_VOLUNTEER,
      "Wants to start chapter" => MEMBER_ATTRS_START_CHAPTER
  }

  def self.import_file(filename)
    state_chapter_id = Chapter.state_wide.id
    index = 0
    CSV.foreach(filename) do |row|
      if index > 0
        email = row[DATABANK_COL_TO_INDEX[:email]]
        if Member.find_by_email(email).blank?
          member = Member.new
          message_control_for_member = nil
          row.each_with_index do |column_value, index|
            col_name = DATABANK_INDEX_TO_COL[index]
            if col_name == :unsubscribe
              if column_value =~ /^[Tt]/
                message_control_for_member = MessageControl.new(unsubscribe_type: MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL, control_type: MessageControl::CONTROL_TYPE_UNSUBSCRIBE)
              end
            else
              if !([:id, :created_at, :updatd_at].include?(col_name))
                member.send("#{col_name}=", column_value)
              end
            end
          end

          member.chapter_id = state_chapter_id
          member.save

          if message_control_for_member
            member.message_controls << message_control_for_member
          end
        end
      end
      index += 1
    end
  end

  def self.export(members)
    CSV.generate(headers: true) do |csv|
      csv << ["Email", "First name", "Middle initial", "Last name",
              "Home phone", "Mobile phone", "Work phone",
              "Address #1", "Address #2", "City", "Zip",
              "Company", "User Type", "Chapter",
              "Source", "Subcaucus", "District", "General Tags",
              "Email Unsubscribe"]
      members.
        includes(:potential_chapter).
        includes(:chapter).
        includes(:sources).
        includes(:subcaucuses).
        includes(:districts).
        includes(:general_tags).
        includes(:message_controls).
        each do |member|
        data = [
          member.email, member.first_name, member.middle_initial,
          member.last_name,
          member.home_phone, member.mobile_phone, member.work_phone,
          member.address_1, member.address_2, member.city, member.zip,
          member.company, member.user_type, member.chapter_for_type,
          tags_for_export(member, :sources),
          tags_for_export(member, :subcaucuses),
          tags_for_export(member, :districts),
          tags_for_export(member, :general_tags),
          member.email_unsubscribe
        ]
        csv << data.map{|d| d || ""}
      end
    end
  end

  def self.tags_for_export(member, sym)
    member.send(sym).join(":")
  end

  def self.filtered(chapter, members, restrict_by_chapter,
                              member_type, source, subcaucus, district,
                              general_tag, search, attr_type)
    if !chapter.is_state_wide || restrict_by_chapter
      if member_type == Member::MEMBER_TYPE_POTENTIAL
        members = members.potential_chapter_members(chapter)
      elsif member_type == Member::MEMBER_TYPE_MEMBER
        members = members.chapter_members(chapter)
      elsif :member_type == Member::MEMBER_TYPE_USER_MEMBER
        members = members.chapter_members(chapter).with_user
      elsif :member_type == Member::MEMBER_TYPE_NON_MEMBER
        members = members.non_members_with_chapter(chapter)
      elsif :member_type == Member::MEMBER_TYPE_NON_USER_MEMBER
        members = members.chapter_members(chapter).non_user_members
      else
        members = members.all_chapter_members(chapter)
      end
    else
      if :member_type == Member::MEMBER_TYPE_MEMBER
        members = members.without_user
      elsif :member_type == Member::MEMBER_TYPE_USER_MEMBER
        members = members.with_user
      elsif :member_type == Member::MEMBER_TYPE_NON_MEMBER
        members = members.non_members
      elsif :member_type == Member::MEMBER_TYPE_NON_USER_MEMBER
        members = members.non_user_members
      else
        # no filter needed here
      end
    end

    if source
      members = members.tagged_with(source, on: 'sources')
    end

    if subcaucus
      members = members.tagged_with(subcaucus, on: 'subcaucuses')
    end

    if district
      members = members.tagged_with(district, on: 'districts')
    end

    if general_tag
      members = members.tagged_with(general_tag, on: 'general_tags')
    end

    members = members.filtered_by_string(search) if search
    members = members.filtered_by_attrs(attr_type) if attr_type
    member_ids = members.pluck(:id).uniq

    members = members.where(id: member_ids)
    members = members.order('city asc')

    members
  end

  def name
    if first_name || last_name
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  def address
    [([address_1, address_2].reject(&:nil?).join(' ')), city, state, "United States"].compact.join(', ')
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

  def user_type
    if user
      'user'
    else
      if is_non_member
        if potential_chapter_id.present?
          "potential_chapter_member"
        else
          'non_member'
        end
      else
        'member'
      end
    end
  end

  def chapter_for_type
    if user
      chapter&.name
    elsif potential_chapter
      potential_chapter&.name
    else
      ""
    end
  end

  def email_unsubscribe
    (message_controls.all.select do |mc|
        mc.unsubscribe_type == 'email' && mc.control_type == 'unsubscribe'
      end.present?) ? "true" : "false"
  end
end
