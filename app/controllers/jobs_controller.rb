class JobsController < ApplicationController
  before_action :set_job, only: [:show, :destroy]

  def index
    @jobs = JobPolicy::Scope.new(current_user, Delayed::Job).resolve
  end

  def show
  end

  def destroy
    @job.destroy
    redirect_to jobs_path
  end

  private

  def set_job
    @job = Delayed::Job.find(params[:id])
    policy = JobPolicy.new(current_user, @job)
    unless policy.public_send("#{action_name}?")
      raise NotAuthorizedError, query: action_name, record: @job, policy: policy
    end
  end
end