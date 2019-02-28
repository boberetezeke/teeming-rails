class ContactAttemptsController < ApplicationController
  before_action :set_contact_attempt, only: [:edit, :update, :destroy]

  def create
    @contact_attempt = ContactAttempt.new(contact_attempt_params)
    @contact_attempt.save
    @contactee = @contact_attempt.contactee
    @contact_attempt.set_accessors

    respond_with(@contact_attempt, location: @contact_attempt.contactee)
  end

  def edit
    @contact_attempt.set_accessors
  end

  def update
    @contact_attempt.update(contact_attempt_params)

    respond_with(@contact_attempt, location: @contact_attempt.contactee)
  end

  def destroy
    contactee = @contact_attempt.contactee
    @contact_attempt.destroy

    redirect_to contactee
  end

  private

  def set_contact_attempt
    @contact_attempt = ContactAttempt.find(params[:id])
    authorize @contact_attempt
  end

  def contact_attempt_params
    params.require(:contact_attempt).permit(:contact_type, :direction_type, :result_type,
                                            :notes, :contactee_id,
                                            :attempted_at_time_str, :attempted_at_date_str)
  end
end