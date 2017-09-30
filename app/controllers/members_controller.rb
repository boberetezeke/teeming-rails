class MembersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize Member
  end
end