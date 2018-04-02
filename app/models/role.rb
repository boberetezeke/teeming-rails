class Role < ApplicationRecord
  has_many :users
  has_many :privileges

  has_many :officer_assignments
  has_many :officers, through: :officer_assignments

  scope :uncombined, ->{ where(Role.arel_table[:combined].eq(nil).or(Role.arel_table[:combined].eq(false))) }

  has_one :user

  def combined?
    combined
  end

  PRIVILEGES = [
      # action                  # subject       # method name
      ['manage_external',       'candidacy'                                   ],

      ['write',                 'chapter'                                     ],

      ['view_internal',         'election'                                    ],
      ['manage_internal',       'election'                                    ],

      ['write',                 'event'                                       ],

      ['view',                  'member'                                      ],

      ['send',                  'message'                                     ],

      ['write',                 'officer'                                     ],
      ['assign',                'officer'                                     ],

      ['view',                  'questionnaire'                               ],
      ['write',                 'questionnaire'                               ],

      ['assign',                'role'                                        ],

      ['show_tallies',          'vote',         'show_vote_tallies'           ],
      ['enter',                 'vote'                                        ],
      ['delete',                'vote'                                        ],
      ['download',              'vote'                                        ],
      ['generate_tallies_for',  'vote',         'generate_vote_tallies'       ],
  ]

  PRIVILEGES.each do |action, subject, method_name|
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

    define_method("new_#{method_name}_privilege") do |scope: {}|
      Privilege.new(subject: subject, action: action, scope: scope ? scope.to_json : nil)
    end

    define_method("add_#{method_name}_privilege") do |scope: {}|
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