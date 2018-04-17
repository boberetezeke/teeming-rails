class MembersController < ApplicationController
  before_action :authenticate_user!

  before_action :set_chapter
  before_action :set_context_params
  before_action :set_member, only: [:show, :edit, :update]

  def index
    authorize_with_args Member, @context_params
    @chapter = Chapter.find(params[:chapter_id])

    @members = policy_scope(Member).includes(:user).references(:user)

    if params[:member_type] == Member::MEMBER_TYPE_ALL
      @members = @members.all_chapter_members(@chapter)
      @title = "Chapter and Potential Members"
    elsif params[:member_type] == Member::MEMBER_TYPE_POTENTIAL
      @members = @members.potential_chapter_members(@chapter)
      @title = "Potential Members"
    else
      @title = "Chapter Members"
      @members = @members.chapter_members(@chapter)
    end

    @members = @members.filtered_by_string(params[:search]) if params[:search]
    @members = @members.filtered_by_attrs(params[:attr_type]) if params[:attr_type]

    @members = @members.paginate(page: params[:page], per_page: params[:per_page])
    @members = @members.order('city asc')

    breadcrumbs members_breadcrumbs, @title
  end

  def show
    @user = @member.user

    breadcrumbs members_breadcrumbs, @member.name
  end

  def edit
    breadcrumbs members_breadcrumbs, "Edit #{@member.name}"
  end

  def update
    @member.update(member_params)
    @member.user.update_role_from_roles
    respond_with(@member)
  end

  private

  def member_params
    params.require(:member).permit(user_attributes: [:id, {role_ids: [], officer_ids: []}])
  end

  def set_member
    @member = Member.find(params[:id])
    authorize @member
  end

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end

  def set_context_params
    @context_params = @chapter ? { chapter_id: @chapter.id } : {}
  end

  def members_breadcrumbs
    if @member
      ["Members", chapter_members_path(@member.chapter)]
    else
      [@chapter.name, chapter_path(@chapter)]
    end
  end
end