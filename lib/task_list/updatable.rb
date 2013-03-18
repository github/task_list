# Include in models that need to update task list items.
module TaskList::Updatable
  # Public: updates the task list item to match `checked`.
  #
  #   - item:     the item index Integer number
  #   - checked:  the Boolean checked value
  #
  # Returns true if updated.
  def update_task_list(item, checked, key = instrument_task_list_update_key)
    updated = TaskList.new(body).update(item, checked)
    attribute = respond_to?(:description=) ? :description : :body
    update_attributes! attribute => updated.source
    instrument :update_task_list, :checked => checked,
      :class_key => key if instrument_task_list_update?
  end

  # Internal: whether to instrument task list updates.
  def instrument_task_list_update?
    true
  end

  def instrument_task_list_update_key
    self.class.name.underscore
  end
end
