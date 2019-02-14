class ContactBanksController < ApplicationController
  before_action :set_contact_bank, only: [:show, :edit, :update]

  def index
    @contact_banks = policy_scope(ContactBank)
  end

  def show
  end

  def new2
    @chapter = Chapter.find(params[:chapter_id])
    @contact_bank = ContactBank.new
    @contact_bank.member_ids = params[:member_ids]
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

  private

  def set_contact_bank
    @contact_bank = ContactBank.find(params[:id])
    authorize @contact_bank
  end

  def contact_bank_params
    params.require(:contact_bank).permit(:member_ids_string, :notes, :script, :name, user_ids: [], member_ids: [])
  end
end