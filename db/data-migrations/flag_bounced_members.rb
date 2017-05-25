class FlagBouncedMembers < ActiveRecord::Migration[5.0]
  require 'csv'

  def up
    bad_emails = []

    blocks_text = File.read(
      Rails.root.join('lib', 'data', 'suppressions', 'suppression_blocks.csv')
    )
    blocks = CSV.parse(blocks_text, :headers => true, :encoding => 'ISO-8859-1')
    blocks.each { |row| bad_emails.push(row['email'])}

    bounces_text = File.read(
      Rails.root.join('lib', 'data', 'suppressions', 'suppression_bounces.csv')
    )
    bounces = CSV.parse(bounces_text, :headers => true, :encoding => 'ISO-8859-1')
    bounces.each { |row| bad_emails.push(row['email'])}

    invalids_text = File.read(
      Rails.root.join('lib', 'data', 'suppressions', 'suppression_invalid_emails.csv')
    )
    invalids = CSV.parse(invalids_text, :headers => true, :encoding => 'ISO-8859-1')
    invalids.each { |row| bad_emails.push(row['email'])}

    requests_text = File.read(
      Rails.root.join('lib', 'data', 'suppressions', 'suppression_manual.csv')
    )
    requests = CSV.parse(requests_text, :headers => true, :encoding => 'ISO-8859-1')
    requests.each { |row| bad_emails.push(row['email'])}

    spams_text = File.read(
      Rails.root.join('lib', 'data', 'suppressions', 'suppression_spam_reports.csv')
    )
    spams = CSV.parse(spams_text, :headers => true, :encoding => 'ISO-8859-1')
    spams.each { |row| bad_emails.push(row['email'])}

    bad_emails.each do |email|
      member = Member.find_by_email(email)
      member.update(status: 'block') if member
    end
  end

  def down
  end
end
