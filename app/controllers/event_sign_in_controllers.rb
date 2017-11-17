class EventSignInsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @event_sign_in = EventSignIn.new(event_id: params[:event_id])
  end

  def create
    @event_sign_in = EventSignIn.new(event_sign_in_params)
    if @event_sign_in.save
      redirect_to new_event_event_sign_in_path(params[:event_id])
    else
      render 'new'
    end
  end
end

