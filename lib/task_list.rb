require 'task_list/version'

# encoding: utf-8
class TaskList
  attr_reader :record

  # `record` is the resource with the Markdown source text with task list items
  # following this syntax:
  #
  #   - [ ] a task list item
  #   - [ ] another item
  #   - [x] a completed item
  #
  def initialize(record)
    @record = record
  end

  # Public: return the TaskList::Summary for this task list.
  #
  # Returns a TaskList::Summary.
  def summary
    @summary ||= TaskList::Summary.new(record.task_list_items)
  end

  class Item < Struct.new(:index, :checkbox_text, :source)
    Complete = "[x]".freeze # see TaskListFilter
    def complete?
      checkbox_text == Complete
    end
  end

  class Summary < Struct.new(:items)
    # Public: returns true if there are any TaskList::Item objects.
    def items?
      item_count > 0
    end

    # Public: returns the number of TaskList::Item objects.
    def item_count
      items.size
    end

    # Public: returns the number of complete TaskList::Item objects.
    def complete_count
      items.select{ |i| i.complete? }.size
    end

    # Public: returns the number of incomplete TaskList::Item objects.
    def incomplete_count
      items.select{ |i| !i.complete? }.size
    end
  end
end
