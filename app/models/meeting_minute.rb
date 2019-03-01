class MeetingMinute < Note
  belongs_to :chapter

  scope :published, ->{ where(arel_table[:published_at].not_eq(nil)) }

  def is_draft?
    published_at.nil?
  end
end