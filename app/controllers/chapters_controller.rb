class ChaptersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @chapters = Chapter.all
    @title = "Chapters"

    breadcrumbs chapters_breadcrumbs(include_link: false)
  end

  def show
    @chapter = Chapter.find(params[:id])
    @context_params = {chapter_id: params[:id]}

    @title = "#{@chapter.name} Chapter"
    breadcrumbs chapters_breadcrumbs, @chapter.name
  end

  private

  def chapters_breadcrumbs(include_link: true)
    ["Chapters", include_link ? chapters_path : nil]
  end

end