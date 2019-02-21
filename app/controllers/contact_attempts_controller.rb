class ContactAttemptsController < ApplicationController
  def create
    @contact_attempt = ContactAttempt.new(contact_attempt_params)
    @contact_attempt.save
    @contactee = @contact_attempt.contactee
    @contact_attempt.set_accessors

    respond_with(@contact_attempt, location: @contact_attempt.contactee)
  end

  private

  def contact_attempt_params
    params.require(:contact_attempt).permit(:contact_type, :direction_type, :result_type,
                                            :notes, :contactee_id,
                                            :attempted_at_time_str, :attempted_at_date_str)
  end
end