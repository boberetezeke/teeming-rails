class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :join, :enter]
  def index
    @accounts = Account.all
  end

  def new
    @account = Account.new
  end

  def show
    @account = Account.find(params[:id])
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(accounts_params)
    @account.user_account_memberships << UserAccountMembership.new(user: current_user, role: UserAccountMembership::ROLE_OWNER)
    @account.save

    respond_with @account
  end

  def update
    @account = Account.find(params[:id])
    @account.update(accounts_params)

    respond_with @account
  end

  def destroy
    @account.destroy
    redirect_to accounts_path
  end

  def join
    @account = Account.find(params[:id])
  end

  def enter
    current_user.select_account(@account)
    redirect_to root_path
  end

  private

  def set_account
    @account = Account.find(params[:id])
    authorize @account
  end

  def accounts_params
    params.require(:account).permit(:name)
  end
end