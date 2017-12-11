class Role < ApplicationRecord
  has_many :users
  has_many :privileges

  PRIVILEGES = [
      # action                  # subject       # method name
      ['view_internal',         'election'                                    ],
      ['manage_internal',       'election'                                    ],

      ['write',                 'event'                                       ],

      ['show_tallies',          'vote',         'show_vote_tallies'           ],
      ['enter',                 'vote'                                        ],
      ['delete',                'vote'                                        ],
      ['download',              'vote'                                        ],
      ['generate_tallies_for',  'vote',         'generate_vote_tallies'       ],

      ['view',                  'member'                                      ],
      ['send',                  'message'                                     ],
      ['manage_external',       'candidacy'                                   ],
      ['view',                  'questionnaire'                               ],
      ['write',                 'questionnaire'                               ],
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
  end
end