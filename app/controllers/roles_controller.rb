class RolesController < ApplicationController
  def index
    @roles = Role.uncombined

    breadcrumbs ["Home", root_path], "Roles"
  end

  def show
    @role = Role.find(params[:id])

    breadcrumbs ["Roles", roles_path], @role.name
  end

  private

  def set_member
    @chapter = Chapter.find(params[:id])
    authorize_with_args @chapter, {chapter_id: params[:id]}
  end

  def member_params
    params.require(:chapter).permit(:name)
  end
end