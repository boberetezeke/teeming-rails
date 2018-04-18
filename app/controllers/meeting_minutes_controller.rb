class MeetingMinutesController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :set_context
  before_action :set_context_params

  before_action :set_meeting_minute, only: [:show, :edit, :update, :destroy]

  def index
    @chapter = Chapter.find(params[:chapter_id])

    @meeting_minutes = @chapter.meeting_minutes
    @meeting_minutes = policy_scope_with_args(@meeting_minutes, @context_params)

    breadcrumbs [@chapter.name, @chapter], "Meeting Minutes"
  end

  def show
    breadcrumbs meeting_minutes_breadcrumbs(chapter: @meeting_minute.chapter), truncate(@meeting_minute.title, length: 25)
  end

  def new
    @meeting_minute = MeetingMinute.new(chapter: @chapter)
    breadcrumbs meeting_minutes_breadcrumbs, "New Meeting Minutes"
  end

  def create
    @meeting_minute = MeetingMinute.new(meeting_minute_params)
    set_published_at(@meeting_minute)
    @meeting_minute.save

    respond_with @meeting_minute, location: ->{ chapter_meeting_minutes_path(@meeting_minute, @context_params) }
  end

  def edit
    breadcrumbs(meeting_minutes_breadcrumbs(chapter: @meeting_minute.chapter), truncate("Edit #{@meeting_minute.title}", length: 25))
  end

  def update
    @meeting_minute.update(meeting_minute_params)
    set_published_at(@meeting_minute)
    respond_with @meeting_minutes, location: ->{ meeting_minute_path(@meeting_minute, @context_params) }
  end

  def destroy
    @meeting_minute.destroy
    redirect_to chapter_meeting_minutes_path(@meeting_minute.chapter)
  end

  private

  def set_published_at(meeting_minute)
    if params['commit'] == "Save" && @meeting_minute.published_at.nil?
      meeting_minute.published_at = Time.now
    end
  end

  def set_context
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id].present?
  end

  def set_context_params
    @context_params = {}
    @context_params.merge!(@chapter ? { chapter_id: @chapter.id } : {})
  end

  def meeting_minute_params
    params.require(:meeting_minute).permit(:title, :body, :chapter_id)
  end

  def set_meeting_minute
    @meeting_minute = MeetingMinute.find(params[:id])
    authorize @meeting_minute
  end


  def meeting_minutes_breadcrumbs(include_link: true, chapter: nil)
    ["Meeting Minutes", include_link ? chapter_meeting_minutes_path(chapter || @chapter) : nil]
  end
end