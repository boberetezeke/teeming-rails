class EventRsvpsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @event_rsvp = find_existing_rsvp(@event)
    @event_rsvp = EventRsvp.create(user: current_user, event: @event, during_initialization: true) unless @event_rsvp
    redirect_to edit_event_rsvp_path(@event_rsvp)
  end

  def edit
    @event_rsvp = EventRsvp.find(params[:id])
    @event = @event_rsvp.event
  end

  def update
    @event_rsvp = EventRsvp.find(params[:id])
    @event = @event_rsvp.event
    if @event_rsvp.update(event_rsvp_params)
      redirect_to @event_rsvp.event
    else
      render 'edit'
    end
  end

  private

  def find_existing_rsvp(event)
    EventRsvp.where(event_id: event.id, user_id: current_user.id).first
  end

  def event_rsvp_params
    params.require(:event_rsvp).permit(:rsvp_type, :event_id, :user_id)
  end
end