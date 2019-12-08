class Role < ApplicationRecord
  belongs_to :account

  has_many :users
  has_many :privileges, dependent: :destroy

  # has_many :officer_assignments, dependent: :destroy
  # has_many :officers, through: :officer_assignments
  alias_method :old_dup, :dup

  scope :uncombined, ->{ where(Role.arel_table[:combined].eq(nil).or(Role.arel_table[:combined].eq(false))) }

  has_one :user

  def combined?
    combined
  end

  def dup
    new_role = self.old_dup
    new_role.privileges = self.privileges.map{ |privilege| privilege.dup }
    new_role
  end

  def self.descriptions_for(privilege)
    _, _, _, desc = PRIVILEGES.select{|action, subject, method_name, descriptions| action == privilege.action && subject == privilege.subject}.first
    desc ? desc : []
  end

  PRIVILEGES = [
      # action                  # subject       # method name
      # description (allows the user to...)
      ['manage_external',       'candidacy',    nil,
       [
        "set external races as official",
        "see messages sent to external candidates",
        "manage (add/edit/delete) officially marked races",
        "manage (add/edit/delete/unlock questionnaire) candidacies in officially marked races",
        "manage the candidate questionnaires",
        "see an external candidate's customized questionnaire link"
       ]
      ],

      ['write',                 'chapter',     nil,
        [
           "manage (add/edit/delete) chapters"
        ]
      ],

      ['manage_internal',       'election',   nil,
       [
         "view all internal elections",
         "view all internal candidates",
         "manage (add/edit/delete) races for internal elections",
         "manage (add/edit/delete) questionnaires for candidacies for internal elections"
       ]
      ],

      ['write',                 'event',      nil,
       [
         "manage (add/edit/delete) events"
       ]
      ],

      ['view',                  'member',     nil,
       [
         "view shared member information and volunteer preferences"
       ]
      ],

      ['write',                 'member',     nil,
       [
           "manage member information for members who aren't users"
       ]
      ],

      ['send',                  'message',    nil,
        [
          "manage (send/save draft/edit draft/delete) messages to users"
        ]
      ],

      ['write',                 'meeting_minute', nil,
       [
         "manage (add/edit/delete) meeting minutes"
       ]
      ],

      ['write',                 'officer',    nil,
       [
         "manage (add/edit/delete) chapter officers and their roles"
       ]
      ],

      ['view',                  'questionnaire', nil,
       [
        "view questionnaires before being attached to issues or races???"
       ]
      ],
      ['write',                 'questionnaire', nil,
       [
         "manage (add/edit/delete) questionnaires"
       ]
      ],

      ['write',                 'contact_bank', nil,
       [
         "manage (add/edit/delete) contact banks"
       ]
      ],

      ['show_tallies',          'vote',         'show_vote_tallies',
       [
         "view vote tallies"
       ]
      ],

      ['enter',                 'vote',         nil,
       [
         "enter in paper ballots for internal election"
       ]
      ],

      ['delete',                'vote',         nil,
       [
         "delete all votes in an internal election (after votes have been downloaded)"
       ]
      ],

      ['download',              'vote',         nil,
       [
         "download votes in an internal election"
       ]
      ],

      ['generate_tallies_for',  'vote',         'generate_vote_tallies',
       [
         "generate vote tallies for an internal election"
       ]
      ],
  ]

  PRIVILEGES.each do |action, subject, method_name, description|
    method_name = "#{action}_#{subject.pluralize}" unless method_name
    define_method("can_#{method_name}?") do
      privilege = privileges.where(action: action, subject: subject).first
      if privilege
        privilege.parsed_scope
      else
        nil
      end
    end

    define_method("scope_for_#{method_name}") do
      privileges.where(action: action, subject: subject).first.parsed_scope
    end

    define_method(method_name) do
      privileges.where(action: action, subject: subject).first
    end

    define_method("new_#{method_name}_privilege") do |scope: nil|
      Privilege.new(subject: subject, action: action, scope: scope ? scope.to_json : nil)
    end

    define_method("add_#{method_name}_privilege") do |scope: nil|
      privilege = send("new_#{method_name}_privilege", scope: scope)
      self.privileges << privilege unless send("find_#{method_name}_privilege", privilege)
    end

    define_method("remove_#{method_name}_privilege") do |privilege|
      send("find_#{method_name}_privilege", privilege).destroy
    end

    define_method("find_#{method_name}_privilege") do |privilege|
      self.privileges.where(action: privilege.action,  subject: privilege.subject, scope: privilege.scope).first
    end
  end
end