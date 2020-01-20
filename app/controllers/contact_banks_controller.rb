class ContactBanksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact_bank, only: [:show, :edit, :update, :next_contactee]

  def index
    @contact_banks = policy_scope(ContactBank)
    @contact_banks = @contact_banks.joins(:contactors).where(Contactor.arel_table[:user_id].eq(current_user.id))
    breadcrumbs ["Home", root_path], "Contact Banks"
  end

  def show
    breadcrumbs ["Contact Banks", contact_banks_path], @contact_bank.name
  end

  def new2
    @chapter = Chapter.find(params[:chapter_id])
    @contact_bank = ContactBank.new(chapter: @chapter)
    @contact_bank.member_ids = params[:member_ids].split(/ /)
    render :new
  end

  def new
    @chapter = Chapter.find(params[:chapter_id])
  end

  def create
    @contact_bank = ContactBank.new(contact_bank_params)
    @contact_bank.owner = current_user
    @contact_bank.save

    respond_with @contact_bank
  end

  def edit
    @chapter = @contact_bank.chapter
  end

  def update
    @contact_bank.update(contact_bank_params)

    respond_with @contact_bank
  end

  def next_contactee
    uncontacteds = @contact_bank.contactees.unattempted
    if uncontacteds.present?
      contactees = uncontacteds
    else
      contactees = @contact_bank.contactees.contacted_by(@contact_bank.contactor_for_user(current_user))
    end

    if contactees.present?
      contactee = contactees.shuffle.first

      redirect_to contactee
    else
      flash[:notice] = "There is no one else to contact."
      redirect_to @contact_bank
    end
  end

  private

  def set_contact_bank
    @contact_bank = ContactBank.find(params[:id])
    authorize @contact_bank
  end

  def contact_bank_params
    params.require(:contact_bank).permit(:member_ids_string, :notes, :script, :name, :chapter_id, user_ids: [], member_ids: [])
  end
end