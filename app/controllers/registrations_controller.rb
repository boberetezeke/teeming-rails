class RegistrationsController < Devise::RegistrationsController
  def new
    # if Account.first.registration_disabled
    #   flash[:notice] = Account.first.registration_disabled_reason
    #   redirect_to root_path
    # else
    #   super
    # end

    super
  end
  #
  # def create
  #   if Account.first.registration_disabled
  #     flash[:notice] = Account.first.registration_disabled_reason
  #     redirect_to root_path
  #   else
  #     super
  #   end
  # end
end