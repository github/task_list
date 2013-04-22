incomplete = "[ ]"
complete   = "[x]"

# Pattern used to identify all task list items.
# Useful when you need iterate over all items.
itemPattern = ///
  ^
  (?:\s*[-+*]|(?:\d+\.))? # optional list prefix
  \s*                     # optional whitespace prefix
  (                       # checkbox
    #{complete.  replace(/([\[\]])/g, "\\$1")}|
    #{incomplete.replace(/([\[\]])/g, "\\$1")}
  )
  (?=\s)                  # followed by whitespace
///

# Used to filter out code fences from the source for comparison only.
# http://rubular.com/r/x5EwZVrloI
# Modified slightly due to issues with JS
codeFencesPattern = ///
  ^`{3}           # ```
    (?:\s*\w+)?   # followed by optional language
    [\S\s]        # whitespace
  .*              # code
  [\S\s]          # whitespace
  ^`{3}$          # ```
///mg

# Used to filter out potential mismatches (items not in lists).
# http://rubular.com/r/OInl6CiePy
itemsInParasPattern = ///
  ^
  (
    #{complete.  replace(/[\[\]]/g, "\\$1")}|
    #{incomplete.replace(/[\[\]]/g, "\\$1")}
  )
  .+
  $
///g

# Given the source text, updates the appropriate task list item to match the
# given checked value.
#
# Returns the updated String text.
updateTaskListItem = (source, itemIndex, checked) ->
  clean = source.replace(/\r/g, '').replace(codeFencesPattern, '').
    replace(itemsInParasPattern, '').split("\n")
  index = 0
  result = for line in source.split("\n")
    if line in clean && line.match(itemPattern)
      index += 1
      if index == itemIndex
        line =
          if checked
            line.replace(incomplete, complete)
          else
            line.replace(complete, incomplete)
    line
  result.join("\n")

# Task list checkboxes are rendered as disabled by default
# because rendered user content is cached without regard
# for the viewer. Enables the checkboxes and applies the
# correct list style, if the viewer is able to edit the comment.
enableTaskList = (comment) ->
  if comment.find('.js-comment-field').length > 0
    comment.
      find('.task-list-item').addClass('enabled').
      find('.task-list-item-checkbox').attr('disabled', null)
    comment.trigger 'tasklist:enabled'

disableTaskList = (comment) ->
  comment.
    find('.task-list-item').removeClass('enabled').
    find('.task-list-item-checkbox').attr('disabled', 'disabled')
  comment.trigger 'tasklist:disabled'

# Submit updates to task list items asynchronously.
# Successful updates won't require re-rendering to represent reality.
updateTaskList = (item) ->
  comment = item.closest '.js-comment'
  form    = comment.find 'form.js-comment-update'
  field   = form.find '.js-comment-field'
  index   = parseInt item.attr('data-item-index')
  checked = item.prop 'checked'

  disableTaskList comment

  field.val updateTaskListItem(field.val(), index, checked)
  form.trigger 'tasklist:updateSend', [index, checked]
  form.one 'ajaxComplete', ->
    form.trigger 'tasklist:updateComplete'
  form.submit()

# When the task list item checkbox is updated, submit the change
$(document).on 'change', 'input.task-list-item-checkbox[type=checkbox]', ->
  updateTaskList $(this)

$.pageUpdate ->
  $('.js-comment').each ->
    enableTaskList $(this)
