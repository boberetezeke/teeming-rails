class BrochureController < ApplicationController
  # layout "application_ourrev"

  def home
    @accounts = Account.all
  end
end