class ContacteesController < ApplicationController
  before_action :set_contactee, only: [:show]

  def show
    @contact_attempt = ContactAttempt.new(contactee: @contactee)
  end

  private

  def set_contactee
    @contactee = Contactee.find(params[:id])
    authorize @contactee
  end
end