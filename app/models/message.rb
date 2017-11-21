class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  has_many :message_recipients
  belongs_to :member_group

  scope :for_chapter, ->(chapter) { where(chapter_id: chapter.id) }

  def create_message_recipients
    member_group.all_members(scope, chapter).find_each do |member|
      self.message_recipients << MessageRecipient.new(member: member)
    end
  end
end
