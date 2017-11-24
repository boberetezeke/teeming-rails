class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  belongs_to :race
  belongs_to :election
  has_many :message_recipients
  belongs_to :member_group

  scope :for_chapter, ->(chapter) { where(chapter_id: chapter.id) }

  def create_message_recipients
    if race
      race.candidacies.each do |candidacy|
        self.message_recipients << MessageRecipient.new(candidacy: candidacy)
      end
    elsif election
    else
      member_group.all_members(chapter).find_each do |member|
        self.message_recipients << MessageRecipient.new(member: member)
      end
    end
  end

  def sent?
    sent_at.present?
  end
end
