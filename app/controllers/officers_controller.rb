class OfficersController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_chapter
  before_action :set_context_params
  before_action :set_officer, only: [:show, :edit, :update, :destroy]

  def index
    authorize_with_args Officer, @context_params
    @chapter = Chapter.find(params[:chapter_id])

    @officers = policy_scope(Officer).where(chapter: @chapter)
    @title = "Officers"
    @officers = @officers.paginate(page: params[:page], per_page: params[:per_page])

    breadcrumbs officers_breadcrumbs, @title
  end

  def show
    breadcrumbs officers_breadcrumbs, @officer.officer_type
  end

  def new
    @title = "New Officer"
    @officer = Officer.new(chapter: @chapter)

    authorize @officer
    breadcrumbs officers_breadcrumbs, @title
  end

  def create
    @officer = Officer.new(officer_params)
    @officer.chapter_id = @chapter.id
    authorize @officer

    @officer.save
    update_users(@officer.users)

    respond_with(@officer)
  end

  def edit
    breadcrumbs officers_breadcrumbs, "Edit #{@officer.officer_type}"
  end

  def update
    @officer.update(officer_params)
    update_users(@officer.users)

    respond_with(@officer)
  end

  def destroy
    users = @officer.users
    @officer.destroy

    update_users(users)

    redirect_to chapter_officers_path(@officer.chapter)
  end

  private

  def set_officer
    @officer = Officer.find(params[:id])
    authorize @officer
  end

  def update_users(users)
    users.each do |user|
      user.update_role_from_roles
    end
  end

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end

  def set_context_params
    @context_params = @chapter ? { chapter_id: @chapter.id } : {}
  end

  def officer_params
    params.require(:officer).permit(:officer_type, role_ids: [], user_ids: [])
  end

  def officers_breadcrumbs
    if @officer
      ["Officers", chapter_officers_path(@officer.chapter)]
    else
      [@chapter.name, chapter_path(@chapter)]
    end
  end
end