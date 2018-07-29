class EventRsvpsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @event_rsvp = EventRsvp.find(params[:id])
    @event = @event_rsvp.event
  end

  def update
    @event_rsvp = EventRsvp.find(params[:id])
    if @event_rsvp.update(event_rsvp_params)
      redirect_to @event_rsvp.event
    else
      render 'edit'
    end
  end

  private

  def event_rsvp_params
    params.require(:event_rsvp).permit(:rsvp_type, :event_id, :user_id)
  end
end