require 'task_list/version'

class TaskList
  attr_reader :source

  Incomplete  = "[ ]".freeze
  Complete    = "[x]".freeze

  # Pattern used to identify all task list items.
  # Useful when you need iterate over all items.
  ItemPattern = /
    ^
    (?:\s*[-+*]|(?:\d+\.))? # optional list prefix
    \s*                     # optional whitespace prefix
    (                       # checkbox
      #{Regexp.escape(Complete)}|
      #{Regexp.escape(Incomplete)}
    )
    (?=\s)                  # followed by whitespace
  /x

  # Used to filter out code fences from the source for comparison only.
  # http://rubular.com/r/x5EwZVrloI
  CodeFencesPattern = /
    ^`{3}           # ```
      (?:\s*\w+)?$  # followed by optional language
    .+?             # code
    ^`{3}$          # ```
  /xm

  # Used to filter out potential mismatches (items not in lists).
  # http://rubular.com/r/OInl6CiePy
  ItemsInParasPattern = /
    ^
    (
      #{Regexp.escape(Complete)}|
      #{Regexp.escape(Incomplete)}
    )
    .+
    $
  /x

  # `source` is the Markdown source text with task list items following the
  # syntax as follows:
  #
  #   - [ ] a task list item
  #   - [ ] another item
  #   - [x] a completed item
  #
  def initialize(source)
    @source = source || ''
  end

  # Internal: the source cleaned of any potential false matches.
  def cleaned_source
    @cleaned_source ||= source.
      gsub("\r", '').
      gsub(CodeFencesPattern, '').
      gsub(ItemsInParasPattern, '')
  end

  # Public: return the TaskList::Summary for this task list.
  #
  # Returns a TaskList::Summary.
  def summary
    @summary ||= TaskList::Summary.new(self)
  end

  # Public: The TaskList::Item objects for the source text.
  #
  # FIXME: not very dry with #update.
  #
  # Returns an Array of TaskList::Item objects.
  def items
    @items ||=
      begin
        items = []
        lines = source.split("\n")
        clean = cleaned_source.split("\n")

        id = 0
        lines.each do |line|
          if match = item?(line) and clean.include?(line.chomp)
            id += 1
            items << Item.new(id, match, line)
          end
        end

        items
      end
  end

  # Public: updates the task list item's checked state in the source.
  #
  # The source is the original Markdown text where the task list item was
  # identified.
  #
  # Returns a new TaskList with the updated source.
  def update(item_id, checked)
    item_id = Integer(item_id)
    result  = source.split("\n")
    clean   = cleaned_source.split("\n")

    id = 0
    result.map! do |line|
      if item?(line) && clean.include?(line.chomp)
        id += 1
        # the item to update
        if item_id == id
          if checked
            # swap incomplete for complete
            line.sub! Incomplete, Complete
          else
            # and vice versa
            line.sub! Complete,   Incomplete
          end
        end
      end
      line
    end

    self.class.new(result.join("\n"))
  end

  # Internal: shorthand for TaskList.item?
  def item?(text)
    self.class.item?(text)
  end

  # Public: analyze the text to determine if it is a task list item.
  #
  # Returns the matched item String, nil otherwise.
  def self.item?(text)
    text.chomp =~ ItemPattern && $1
  end

  class Item < Struct.new(:index, :checkbox_text, :source)
    def complete?
      checkbox_text == Complete
    end
  end

  class Summary < Struct.new(:task_list)
    # Internal: just use TaskList#items.
    def items
      task_list.items
    end

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
