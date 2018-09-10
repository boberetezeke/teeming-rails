namespace :races  do
  desc "Update questionnaire use_type to candidacy"
  task :update_questionnnaire_use_type => :environment do
    Race.find_each do |race|
      questionnaire = Questionnaire.where(questionnairable_type: 'Race', questionnairable_id: race.id)
      if questionnaire
        puts "updating race(#{race.id}): #{race.name}"
        questionnaire.update(use_type: Questionnaire::USE_TYPE_CANDIDACY)
      end
    end
  end
end
