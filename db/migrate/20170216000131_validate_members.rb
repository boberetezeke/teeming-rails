class ValidateMembers < ActiveRecord::Migration[5.0]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def up
    Member.all.each do |member|
      if (member[:email] =~ VALID_EMAIL_REGEX).nil?
        member.update!(status: 'invalid')
      end
    end

    repeated_emails = Member.valid_email.group(:email)
      .having("count(email) > 1").count.keys

    repeated_emails.each do |email|
      Member.where(email: email)
        .order("databank_id desc")
        .each_with_index do |member, i|

        if i == 0
          member.update!(status: "active")
        else
          member.update!(status: "duplicate")
        end
      end
    end

    Member.where("status IS NULL").each do |member|
      member.update!(status: "active")
    end
  end

  def down
    Member.all.each do |member|
      member.update!(status: nil)
    end
  end
end
