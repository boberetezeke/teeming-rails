class MeetingMinute < Note
  belongs_to :account

  belongs_to :chapter, foreign_key: 'member_group_id'

  scope :published, ->{ where(arel_table[:published_at].not_eq(nil)) }

  def is_draft?
    published_at.nil?
  end
end