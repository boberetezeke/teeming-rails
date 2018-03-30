class EventRsvpsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @event_rsvp = EventRsvp.find(params[:id])
  end

  def update
    @event_rsvp = EventRsvp.find(params[:id])
    if @event_rsvp.update(event_rsvp_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def new
    @event_rsvp = EventRsvp.new(event: params[:event_id], user: current_user)
  end

  def create
    @event_rsvp = EventRsvp.new(event_rsvp_params)
  end

  private

  def event_rsvp_params
    params.require(:event_rsvp).permit(:rsvp_type, :event_id, :user_id)
  end
end