class MemberGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_member_group, only: [:show, :edit, :update]

  def index
    @chapter = selected_account.chapters.find(params[:chapter_id])
    @member_groups = @chapter.member_groups
  end

  def show
    @member_group = MemberGroup.find(params[:id])
    authorize @member_group
  end

  def new
    @member_group = MemberGroup.new(account: selected_account)
  end

  def create
    @member_group = MemberGroup.new(member_group_params)
    @member_group.save

    respond_with @member_group
  end

  def edit
  end

  def update
  end

  private

  def load_member_group
    @member_group = MemberGroup.find(params[:id])
    authorize @member_group
  end
end