class ContacteesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contactee, only: [:show, :edit, :update]

  def show
    @contact_attempt = ContactAttempt.new(contactee: @contactee,
                                          contactor: @contactee.contact_bank.contactor_for_user(current_user),
                                          attempted_at: Time.now,
                                          contact_type: ContactAttempt::CONTACT_TYPE_PHONE_CALL,
                                          direction_type: ContactAttempt::CONTACT_DIRECTION_OUT,
                                          result_type: ContactAttempt::CONTACT_RESULT_LEFT_MESSAGE)
    @contact_attempt.set_accessors
    breadcrumbs [@contactee.contact_bank.name, contact_bank_path(@contactee.contact_bank)], @contactee.member.name ? @contactee.member.name : @contactee.member.id.to_s
  end


  def edit
  end

  def update
    @contactee.update(contactee_params)
    MembersController.handle_tags(@contactee.member, contactee_member_tag_params['member_attributes'])

    respond_with(@contactee, location: @contactee)
  end

  private

  def contactee_params
    params.require(:contactee).permit(member_attributes: [:id] + MembersController.permitted_attributes)
  end

  def contactee_member_tag_params
    params.require(:contactee).permit(member_attributes: MembersController.permitted_tag_attributes)
  end

  def set_contactee
    @contactee = Contactee.find(params[:id])
    authorize @contactee
  end
end