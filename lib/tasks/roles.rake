namespace :roles  do
  desc "create default roles"
  task :create_default_roles => :environment do
    roles = [
      { name: 'state president', privileges: [
          { action: 'write', subject: 'chapter' },
          { action: 'write', subject: 'officer' }
      ]},
      { name: 'chapter president', privileges: [
          { action: 'write', subject: 'officer' }
      ]},
      { name: 'endorser', privileges: [
          { action: 'manage_external', subject: 'candidacy' },
          { action: 'send', subject: 'message' },
          { action: 'view', subject: 'questionnaire' },
          { action: 'write', subject: 'questionnaire' },
      ]},
      { name: 'elections', privileges: [
          { action: 'manage_internal', subject: 'election' },
          { action: 'send', subject: 'message' },
          { action: 'view', subject: 'questionnaire' },
          { action: 'write', subject: 'questionnaire' },
          { action: 'enter', subject: 'vote' },
          { action: 'delete', subject: 'vote' },
          { action: 'download', subject: 'vote' },
          { action: 'show_tallies', subject: 'vote' },
          { action: 'generate_tallies_for', subject: 'vote' },
      ]},
      { name: 'secretary', privileges: [
          { action: 'write', subject: 'meeting_minute' }
      ]},
      { name: 'event coordinator', privileges: [
          { action: 'send', subject: 'message' },
          { action: 'write', subject: 'event' },
      ]},
      { name: 'member coordinator', privileges: [
          { action: 'send', subject: 'message' },
          { action: 'view', subject: 'member' },
          { action: 'write', subject: 'member' },
      ]},
      { name: 'admin', privileges: [
        { action: 'write', subject: 'chapter' },
        { action: 'manage_internal', subject: 'election' },
        { action: 'write', subject: 'event' },
        { action: 'write', subject: 'meeting_minute' },
        { action: 'send', subject: 'message' },
        { action: 'view', subject: 'member' },
        { action: 'write', subject: 'member' },
        { action: 'write', subject: 'officer' },
        { action: 'view', subject: 'questionnaire' },
        { action: 'write', subject: 'questionnaire' },
        { action: 'enter', subject: 'vote' },
        { action: 'delete', subject: 'vote' },
        { action: 'download', subject: 'vote' },
        { action: 'show_tallies', subject: 'vote' },
        { action: 'generate_tallies_for', subject: 'vote' },
      ]},
    ]

    roles.each do |role|
      name = "#{role[:name]}-template"
      unless Role.find_by_name(name)
        puts "creating role: #{name}"
        r = Role.create(name: name)
        role[:privileges].each do |privilege|
          r.privileges << Privilege.new(action: privilege[:action], subject: privilege[:subject])
        end
      end
    end
  end
end

