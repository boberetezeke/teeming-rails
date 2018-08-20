module DistrictVoting
  #
  # group candidate votes by district
  #
  # @param candidacies [Array<Candidacy>] - array of candidacies
  # @param votes [Array<Votes>] - array of votes in this race
  # @return [Hash<String,Array<Array<Candidacy, Vote>>>] - a hash that is from district to an array of two member
  #                                                         arrays of candidacy and a vote object
  #
  def self.group_candidacies_by_district(candidacies, votes)
    candidacies_by_district = {}

    candidacies.each do |candidacy|
      district = district_for_candidacy(candidacy)
      candidacies_by_district[district] ||= []
      vote = votes.select{|v| v.candidacy == candidacy}.first
      candidacies_by_district[district].push([candidacy, vote])
    end

    candidacies_by_district
  end

  #
  # group candidate tallies by district
  #
  # @param tallies [Hash<Candidacy, Integer>] - a hash from candidacy to vote counts
  # @return [Hash<String,Array<Array<Candidacy, Count>>>] - a hash that is from district to an array of two member
  #                                                         arrays of candidacy and a vote count
  #
  def self.group_candidacy_tallies_by_district(tallies)
    candidacies_by_district = {}

    tallies.each do |candidacy, count|
      district = district_for_candidacy(candidacy)
      candidacies_by_district[district] ||= []
      candidacies_by_district[district].push([candidacy, count])
    end

    candidacies_by_district
  end

  def self.district_for_candidacy(candidacy)
    candidacy.answers.where(question_id: district_question.id).first.text
  end

  def self.district_question
    @district_question ||= Question.where(text: 'For the purpose of fulfilling balance requirements put forth in the Our Revolution MN bylaws, specify your congressional district').order('id asc').first
  end

  def self.voting_rules
    "Select one vote per congressional district"
  end

  #
  # validate the votes
  #
  # @param votes - [Array<Vote>] - array of votes selected by user
  # @return [Array<Boolean, Hash<String,Integer>] -
  #   true - votes valid, or false if invalid
  #   if invalid, a map of districts that are voted for too many times and the count of votes in that district
  #
  def self.votes_valid?(votes)
    districts_voted_for = {}
    votes.each do |vote|
      district = district_for_candidacy(vote.candidacy)
      districts_voted_for[district] ||= 0
      districts_voted_for[district] += 1
    end

    is_valid = true
    overflow_districts = {}
    districts_voted_for.each do |district, count|
      if count > 1
        overflow_districts[district] = count
        is_valid = false
      end
    end

    return [is_valid, overflow_districts]
  end
end