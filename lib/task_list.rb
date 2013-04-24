require 'task_list/summary'
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
end
