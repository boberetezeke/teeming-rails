require 'rails_helper'

describe Member do
  DATABANK_HASH = Hash[Member::DATABANK_EXPORT_COLUMNS.map.with_index{|title, index| [title, index]}]

  def hash_to_columns(hash)
    columns = []
    DATABANK_HASH.each do |title, index|
      columns[index] = hash[title.to_sym] || ""
    end
    columns
  end

  def create_file(filename, hashes)
    CSV.open(filename, "w") do |csv|
      hashes.each do |hash|
        csv << hash_to_columns(hash)
      end
    end
  end

  describe ".import_file" do
    let(:charlie) { { email: 'charlie@peanuts.com', first_name: 'Charlie', last_name: 'Brown', city: 'St. Paul', state: 'MN' } }
    let(:lucy)    { { email: 'lucy@peanuts.com', first_name: 'Lucy', last_name: 'VanPelt', city: 'St. Paul', state: 'MN' } }

    it "creates a member record" do
      state_chapter = FactoryBot.create(:chapter, is_state_wide: true)
      create_file("import.csv", [charlie])

      Member.import_file("import.csv")
      expect(Member.count).to eq(1)
      member = Member.first

      expect(member.email).to eq('charlie@peanuts.com')
      expect(member.first_name).to eq("Charlie")
      expect(member.last_name).to eq("Brown")
      expect(member.city).to eq("St. Paul")
      expect(member.state).to eq("MN")
      expect(member.chapter_id).to eq(state_chapter.id)
    end

    it "ignores member records when there exists a user with a duplicate email" do
      FactoryBot.create(:member, email: 'lucy@peanuts.com', first_name: 'Looocy', last_name: 'VanPelt')

      create_file("import.csv", [charlie, lucy])

      Member.import_file("import.csv")
      expect(Member.count).to eq(2)
      charlie_member, lucy_member = Member.order('email asc').to_a

      expect(charlie_member.first_name).to eq("Charlie")
      expect(lucy_member.first_name).to eq("Looocy")
    end
  end
end

