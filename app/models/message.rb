class Message < ApplicationRecord
  belongs_to :user
  has_many :message_recipients

  def create_message_recipients
  end
end
