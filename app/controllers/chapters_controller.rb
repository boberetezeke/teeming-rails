class ChaptersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]

  def index
    @chapters = Chapter.all
    @title = "Chapters"

    breadcrumbs chapters_breadcrumbs(include_link: false)
  end

  def show
    @context_params = {chapter_id: params[:id]}

    @title = "#{@chapter.name} Chapter"
    @tab = params[:tab] || 'activity'
    breadcrumbs chapters_breadcrumbs, @chapter.name
  end

  def new
    @chapter = Chapter.new
  end

  def create
    @chapter = Chapter.new(chapter_params)
    @chapter.save

    respond_with(@chapter)
  end

  def edit
  end

  def update
    @chapter.update(chapter_params)
    respond_with(@chapter)
  end

  def destroy
    if @chapter.members.empty?
      @chapter.destroy
    else
      flash[:alert] = "Can't delete chapter with members in it"
    end
    redirect_to chapters_path
  end

  private

  def set_chapter
    @chapter = Chapter.find(params[:id])
    authorize_with_args @chapter, {chapter_id: params[:id]}
  end

  def chapter_params
    params.require(:chapter).permit(:name)
  end

  def chapters_breadcrumbs(include_link: true)
    ["Chapters", include_link ? chapters_path : nil]
  end

end