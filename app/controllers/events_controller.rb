class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = params[:id]
  end
end