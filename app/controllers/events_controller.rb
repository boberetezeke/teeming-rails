class EventsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @events = Event.all

    breadcrumbs event_breadcrumbs(include_link: false)
  end

  def show
    @event = params[:id]

    breadcrumbs event_breadcrumbs, @event.name
  end

  private

  def event_breadcrumbs(include_link: true)
    ["Events", include_link ? events_path : nil]
  end
end