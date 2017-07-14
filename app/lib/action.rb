class Action
  def action_for(object)
    action_finder = ActionFinder.new(object)
    action_finder.action.new(@user, object, {})
  end

  #
  # creates or finds associated objects and sets the errors array
  #
  # @params errors [Hash<Symbol, Array<String>>] - the errors hash where the keys are the field names and the values are an array of error messages
  # @params params [Hash<String, Hash>] - the params array for an associated object
  # @param klass   [Class] - a class constant for the associated object
  # @param associated_params_key [Symbol] - the key in the params hash for the associated objects params
  # @param action [Symbol] - the action to perform, either (:find_only | :create_or_find)
  # @return [Array|NilClass] - array of associated objects
  #
  def create_or_find_associated_objects(base_object, errors, params, klass, associated_params_key, action = :create_or_find)
    associated_objects = []

    return nil unless ap = params[associated_params_key.to_s]

    ap.each do |associated_params|
      if associated_params.is_a?(ApplicationRecord)
        associated_objects.push(associated_params)
      else
        if action == :find_only
          errors[associated_params_key] = "can only have an :id param"
        else
          associated_object = klass.new(associated_params.merge(account: base_object.account))
          associated_object.valid?
          errors[associated_params_key] = associated_object.errors.messages if associated_object.errors.messages.present?
          associated_objects.push(associated_object)
        end
      end
    end

    associated_objects
  end
end