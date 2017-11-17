class Role < ApplicationRecord
  has_many :users
  has_many :privileges

  PRIVILEGES = [
      # action                  # subject       # method name
      ['view_internal',         'election'                                    ],
      ['modify',                'election'                                    ],

      ['write',                 'event'                                       ],

      ['show_tallies',          'vote',         'show_vote_tallies'           ],
      ['enter',                 'vote'                                        ],
      ['delete',                'vote'                                        ],
      ['download',              'vote'                                        ],
      ['generate_tallies_for',  'vote',         'generate_vote_tallies'       ],

      ['view',                  'member'                                      ],
      ['view_internal',         'candidacy'                                   ],
  ]

  PRIVILEGES.each do |action, subject, method_name|
    method_name = "#{action}_#{subject.pluralize}" unless method_name
    define_method("can_#{method_name}?") do
      privileges.where(action: action, subject: subject).count > 0
    end
  end
end