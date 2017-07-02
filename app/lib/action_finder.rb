class ActionFinder
  def initialize(object_or_class)
    if object_or_class.is_a?(Class)
      object_class = object_or_class
    else
      @object = object_or_class
      object_class = object_or_class.class
    end

    @action_class =         (object_class.to_s + "Action").constantize
  end

  def action
    @action_class
  end
end