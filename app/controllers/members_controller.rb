class MembersController < ApplicationController
  def index
    members = Member.order(:last_name)
      .page(params[:page])
      .per(params[:per])

    render json: members, meta: pagination_dict(members)
  end
end
