class MembersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize Member
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

    breadcrumbs members_breadcrumbs, @title
  end

  def show
    @member = Member.find(params[:id])
    authorize @member

    @user = @member.user

    breadcrumbs members_breadcrumbs, @member.name
  end

  private

  def members_breadcrumbs
    if @member
      ["Members", chapter_members_path(@member.chapter)]
    else
      [@chapter.name, chapter_path(@chapter)]
    end
  end
end