class MembersController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_chapter
  before_action :set_context_params
  before_action :set_member, only: [:show, :edit, :update]

  def index
    authorize_with_args Member, @context_params
    @chapter = Chapter.find(params[:chapter_id])

    @members = policy_scope(Member)
    if params[:show_potential_members]
      @members = @members.potential_chapter_members(@chapter)
      @title = "Potential Members"
    else
      @title = "Chapter Members"
      @members = @members.chapter_members(@chapter)
    end
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