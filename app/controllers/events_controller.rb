class EventsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_chapter
  before_action :set_context_params
  before_action :set_event, only: [:show, :edit, :update, :email, :publish, :unpublish, :destroy]

  def index
    @chapter = Chapter.find(params[:chapter_id])
    @events = policy_scope_with_args(@chapter.events, @context_params)
    authorize_with_args Event, @context_params

    breadcrumbs [@chapter.name, @chapter], "Events"
  end

  def show
    @event_rsvp = @event.event_rsvps.for_user(current_user).first
    breadcrumbs event_breadcrumbs, @event.name
  end

  def new
    @event = Event.new(chapter_id: params[:chapter_id], event_type: Event::EVENT_TYPE_ONLINE_AND_OFFLINE)
    authorize_with_args @event, @context_params
    @member_groups = MemberGroupPolicy::Scope.new(current_user, MemberGroup).resolve

    breadcrumbs event_breadcrumbs, "New Event"
  end

  def create
    @event = Event.new(event_params)
    authorize @event

    if @event.save
      check_event_time
      redirect_to @event
    else
      @member_groups = MemberGroupPolicy::Scope.new(current_user, MemberGroup).resolve
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event.set_accessors
    @member_groups = MemberGroupPolicy::Scope.new(current_user, MemberGroup).resolve

    breadcrumbs event_breadcrumbs, @event.name
  end

  def update
    if @event.update(event_params)
      check_event_time
      redirect_to @event
    else
      @member_groups = MemberGroupPolicy::Scope.new(current_user, MemberGroup).resolve
      render :edit
    end
  end

  def publish
    if @event.published?
      flash[:alert] = "Event is already published"
    elsif @event.occurs_at.nil?
      flash[:alert] = "Can't publish event without a time set"
    else
      @event.publish
    end
    redirect_to @event
  end

  def unpublish
    @event.unpublish
    redirect_to @event
  end

  def email
    redirect_to new_chapter_message_path(@context_params.merge(event_id: @event.id, chapter_id: @event.chapter.id))
  end

  def destroy
    @event.destroy
    redirect_to chapter_events_path(@event.chapter)
  end

  private

  def check_event_time
    if @event.occurs_at && @event.occurs_at < Time.now
      flash[:notice] = "Your event time is in the past"
    end
  end
  def set_event
    @event = Event.find(params[:id])
    authorize_with_args @event, {chapter_id: @event.chapter.id}
  end

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end

  def set_context_params
    @context_params = @chapter ? { chapter_id: @chapter.id } : {}
  end

  def event_params
    params.require(:event).permit(:name, :occurs_at_date_str, :occurs_at_time_str, :description,
                                  :event_type, :online_details,
                                  :location, :chapter_id, :member_group_id, :agenda)
  end

  def event_breadcrumbs(include_link: true)
    ["Events", include_link ? chapter_events_path(@event.chapter) : nil]
  end
end