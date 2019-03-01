class RolesController < ApplicationController
  def index
    @roles = Role.uncombined

    breadcrumbs ["Home", root_path], "Roles"
  end

  def show
    @role = Role.find(params[:id])

    if @role.combined?
      if @role.user == current_user
        breadcrumbs ["Profile", profile_users_path], "Combined role for #{@role.user.name}"
      else
        breadcrumbs [@role.user.name, @role.user.member], "Combined role for #{@role.user.name}"
      end
    else
      breadcrumbs ["Roles", roles_path], @role.name
    end
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