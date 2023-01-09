class SystemSetting < ApplicationRecord
  enum :setup_status => { user_setup: 0, system_setup: 1, done: 2}
  def self.instance
    create if count == 0

    raise "#{count} System Settings exist in the database" if count > 1
    first
  end
end