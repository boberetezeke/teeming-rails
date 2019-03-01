class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def can_for_scope?(scope, context_params=nil)
    self.class.can_for_scope?(@record, scope, context_params)
  end

  def context_params
    self.class.context_params_for_user(@user)
  end

  def self.can_for_scope?(record, scope, context_params=nil)
    if scope.nil? || scope == false
      false
    else
      if scope['chapter_id']
        if context_params
          context_params[:chapter_id].to_i == scope["chapter_id"]
        else
          if record.respond_to?(:chapter_id)
            record.chapter_id == scope['chapter_id']
          else
            false
          end
        end
      else
        true
      end
    end
  end

  def self.context_params_for_user(user)
    user.authorize_args ? user.authorize_args.first : nil
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

    def context_params
      ApplicationPolicy.context_params_for_user(@user)
    end

    def can_for_scope?(scope, context_params=nil)
      ApplicationPolicy.can_for_scope?(nil, scope, context_params)
    end
  end

  class AssociatedObjects
    attr_reader :user

    def initialize(user, record)
      @user = user
      @record = record
    end

    protected

    def chapters_for_scope(scope)
      if scope == {}
        Chapter.all
      else
        Chapter.where(id: scope['chapter_id'])
      end
    end

  end
end
