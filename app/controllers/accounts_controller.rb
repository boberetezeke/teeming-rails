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

    MemberGroup.write_member_groups(@account)

    chapter = Chapter.new(name: "Main", account: @account)
    @account.chapters = [chapter]

    create_default_roles(@account)
    admin_role_template = @account.roles.where(name: 'admin-template').first

    admin_role = admin_role_template.dup
    admin_role.name = "admin"
    admin_role.save

    current_user.role_assignments << RoleAssignment.new(account: @account, role: admin_role)
    current_user.update_role_from_roles(@account)

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
    current_user.select_account(@account)
    redirect_to root_path
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

  def create_default_roles(account)
    default_roles.each do |role|
      create_role(role, account)
    end
  end

  def default_roles
    [
      { name: 'admin', privileges: [
        { action: 'write',                subject: 'chapter' },

        { action: 'write',                subject: 'officer' },

        { action: 'manage_external',      subject: 'candidacy' },

        { action: 'manage_internal',      subject: 'election' },

        { action: 'view',                 subject: 'questionnaire' },
        { action: 'write',                subject: 'questionnaire' },

        { action: 'write',                subject: 'contact_bank' },

        { action: 'enter',                subject: 'vote' },
        { action: 'delete',               subject: 'vote' },
        { action: 'download',             subject: 'vote' },
        { action: 'show_tallies',         subject: 'vote' },
        { action: 'generate_tallies_for', subject: 'vote' },

        { action: 'write',                subject: 'meeting_minute' },

        { action: 'send',                 subject: 'message' },

        { action: 'write',                subject: 'event' },

        { action: 'view',                 subject: 'member' },
        { action: 'write',                subject: 'member' },
      ]},
      { name: 'state president', privileges: [
        { action: 'write', subject: 'chapter' },
        { action: 'write', subject: 'officer' }
      ]},
      { name: 'chapter president', privileges: [
        { action: 'write', subject: 'officer' }
      ]},
      { name: 'endorser', privileges: [
        { action: 'manage_external', subject: 'candidacy' },
        { action: 'send', subject: 'message' },
        { action: 'view', subject: 'questionnaire' },
        { action: 'write', subject: 'questionnaire' },
      ]},
      { name: 'elections', privileges: [
        { action: 'manage_internal', subject: 'election' },
        { action: 'send', subject: 'message' },
        { action: 'view', subject: 'questionnaire' },
        { action: 'write', subject: 'questionnaire' },
        { action: 'enter', subject: 'vote' },
        { action: 'delete', subject: 'vote' },
        { action: 'download', subject: 'vote' },
        { action: 'show_tallies', subject: 'vote' },
        { action: 'generate_tallies_for', subject: 'vote' },
      ]},
      { name: 'secretary', privileges: [
        { action: 'write', subject: 'meeting_minute' }
      ]},
      { name: 'event coordinator', privileges: [
        { action: 'send', subject: 'message' },
        { action: 'write', subject: 'event' },
      ]},
      { name: 'member coordinator', privileges: [
        { action: 'send', subject: 'message' },
        { action: 'view', subject: 'member' },
        { action: 'write', subject: 'member' },
      ]},
    ]
  end

  def create_role(role, account)
    name = "#{role[:name]}-template"
    unless Role.find_by_name(name)
      puts "creating role: #{name}"
      r = Role.create(name: name, account: account)
      role[:privileges].each do |privilege|
        r.privileges << Privilege.new(action: privilege[:action], subject: privilege[:subject])
      end
    end
  end
end