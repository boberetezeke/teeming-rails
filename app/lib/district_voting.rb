module DistrictVoting
  def self.group_candidacies_by_district(candidacies, votes, user)
    candidacies_by_district = {}

    q = Question.where(text: 'For the purpose of fulfilling balance requirements put forth in the Our Revolution MN bylaws, specify your congressional district').order('id desc').first
    candidacies.each do |candidacy|
      answer = candidacy.answers.where(question_id: q.id).first
      candidacies_by_district[answer.text] ||= []
      vote = votes.select{|v| v.candidacy == candidacy}.first
      candidacies_by_district[answer.text].push([candidacy, vote])
    end

    candidacies_by_district
  end

  def self.district_for_candidacy(candidacy)
    q = Question.where(text: 'For the purpose of fulfilling balance requirements put forth in the Our Revolution MN bylaws, specify your congressional district').order('id desc').first
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

  end
end