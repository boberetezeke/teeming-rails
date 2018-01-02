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
    if scope.nil? || scope == false
      false
    else
      if scope['chapter_id']
        if context_params
          context_params[:chapter_id].to_i == scope["chapter_id"]
        else
          if @record.respond_to?(:chapter_id)
            @record.chapter_id == scope['chapter_id']
          else
            false
          end
        end
      else
        true
      end
    end
  end

  def context_params
    @user.authorize_args ? @user.authorize_args.first : nil
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
  end

  class AssociatedObjects
    attr_reader :user

    def initialize(user, record)
      @user = user
      @record = record
    end

    protected

    def chapters_for_scope(scope)
      if scope.nil?
        Chapter.all
      else
        Chapter.where(id: scope['chapter_id'])
      end
    end

  end
end
