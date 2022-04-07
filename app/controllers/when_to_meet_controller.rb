class WhenToMeetController < ApplicationController
  def index
    redirect_to new_when_to_meet_path
  end

  def new
    @when_to_meet = WhenToMeet.new(
      start_date_str: Date.today.strftime("%m/%d/%Y"),
      end_date_str: (Date.today+7).strftime("%m/%d/%Y"),
      starting_hour_str: 9.to_s,
      ending_hour_str: (8+12).to_s,
      users: [],
      time_slots: {})
  end

  def create
    @when_to_meet = WhenToMeet.new(when_to_meet_params)
    @when_to_meet.users = []
    @when_to_meet.time_slots = {}

    # @user = WhenToMeet::User.new(name: when_to_meet_params[:user_name], email: when_to_meet_params[:user_email], is_creator: true)
    # @user.save(@when_to_meet.users)
    # @when_to_meet.add_user(@user)

    if @when_to_meet.save
      redirect_to when_to_meet_path(@when_to_meet.slug)
    else
      render 'new'
    end
  end

  def show
    @when_to_meet = WhenToMeet.find_by_slug(params[:id])
    if @when_to_meet
      @user =
        @when_to_meet.find_user_by_id(params[:user_id]) ||
        WhenToMeet::User.new(name: '', email: '', is_creator: false)
    else
      flash[:alert] = "unable to find when to meet with slug (#{params[:id]})"
      redirect_to when_to_meet_index_path
    end
  end

  def signup
    @when_to_meet = WhenToMeet.find(params[:id])
    @when_to_meet.editing_content = true

    checks = params.permit!.to_h.to_a.select{|k,v| /^check/.match(k)}

    user_email = user_params[:user_email]
    user_name = user_params[:user_name]
    @user = WhenToMeet::User.new(email: user_email, name: user_name, is_creator: false, id: params[:user_id])

    if @user.valid?
      if @user.id
        user = @when_to_meet.find_user_by_id(@user.id)
        user.update(name: @user.name, email: @user.email)
      else
        if user = @when_to_meet.find_user_by_email(@user.email)
          @user = user
        else
          @user.save(@when_to_meet.users)
          @when_to_meet.add_user(@user)
        end
      end

      @when_to_meet.set_time_slot_from_checks_and_user(checks, @user)
      @when_to_meet.save

      redirect_to when_to_meet_user_path(@when_to_meet.slug, user_id: @user.id)
    else
      render 'show'
    end
  end

  def when_to_meet_params
    params.require(:when_to_meet).permit(:name, :start_date_str, :end_date_str, :starting_hour_str, :ending_hour_str, :user_name, :user_email)
  end

  def user_params
    params.permit(:user_name, :user_email)
  end
end