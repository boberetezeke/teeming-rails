class OfficerAssignmentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_officer_assignment, only: [:show, :edit, :update, :destroy]

  def new
    @officer = Officer.find(params[:officer_id])
    @chapter = Chapter.find(params[:chapter_id])
    @officer_assignment = OfficerAssignment.new(officer: @officer)
    breadcrumbs([@officer.name, officer_path(@officer, chapter_id: @chapter.id)], "New Officer Assignment")
  end

  def create
    @chapter = Chapter.find(params[:chapter_id])
    @officer_assignment = OfficerAssignment.new(officer_assignment_params)
    @officer_assignment.save

    respond_with @officer_assignment, location: ->{ officer_path(@officer_assignment.officer) }
  end

  def show
    breadcrumbs officer_assignments_breadcrumbs, @officer_assignment.officer.officer_type
  end

  def edit
    @officer_assignment.set_accessors
    breadcrumbs officer_assignments_breadcrumbs, @officer_assignment.officer.officer_type
  end

  def update
    breadcrumbs officer_assignments_breadcrumbs, @officer_assignment.officer.officer_type

    @officer_assignment.update(officer_assignment_params)

    respond_with(@officer_assignment)
  end

  def destroy
    @officer_assignment.destroy
    redirect_to @officer_assignment.officer
  end

  private

  def officer_assignment_params
    params.require(:officer_assignment).permit(:start_date_str, :reason_for_start, :end_date_str, :reason_for_end, :user_id, :officer_id)
  end

  def officer_assignments_breadcrumbs
    ["Officers", chapter_officers_path(@officer_assignment.officer.chapter)]
  end

  def set_officer_assignment
    @officer_assignment = OfficerAssignment.find(params[:id])
    authorize_with_args @officer_assignment, {chapter_id: @officer_assignment.officer.chapter.id}
  end
end

