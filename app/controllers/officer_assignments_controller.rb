class OfficerAssignmentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_officer_assignment, only: [:show, :edit, :update]

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

  private

  def officer_assignment_params
    params.require(:officer_assignment).permit(:start_date_str, :reason_for_start, :end_date_str, :reason_for_end)
  end

  def officer_assignments_breadcrumbs
    ["Officers", chapter_officers_path(@officer_assignment.officer.chapter)]
  end

  def set_officer_assignment
    @officer_assignment = OfficerAssignment.find(params[:id])
    authorize_with_args @officer_assignment, {chapter_id: @officer_assignment.officer.chapter.id}
  end
end

