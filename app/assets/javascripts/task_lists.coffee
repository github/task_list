# TaskList Behavior
#
#= provides tasklist:enabled
#= provides tasklist:disabled
#= provides tasklist:change
#= provides tasklist:updateSend
#= provides tasklist:updateComplete
#
#= require jquery
#= require crema/events/pageupdate
#= require rails/remote
#
# Enables Task List update behavior.
#
# ### Example Markup
#
#   <div class="js-task-list-container">
#     <ul class="task-list">
#       <li class="task-list-item">
#         <label>
#           <input type="checkbox" class="js-task-list-item-checkbox" data-item-index="1" disabled />
#           text
#         </label>
#       </li>
#     </ul>
#     <form class="js-task-list-form">
#       <textarea class="js-task-list-field">- [ ] text</textarea>
#     </form>
#   </div>
#
# ### Specification
#
# TaskLists MUST be contained in a `div.js-task-list-container`.
#
# TaskList Items SHOULD be an a list (`UL`/`OL`) element.
#
# Task list items MUST match `input.task-list-item-checkbox[type=checkbox]`,
# MUST be `disabled`, and MUST define `data-item-index`. The Item's contents
# SHOULD be wrapped in a `LABEL` element.
#
# TaskLists MUST have a `(form).js-task-list-form` containing a
# `(textarea).js-task-list-field` form element whose `value` attribute is the
# source (Markdown) to be udpated. The source MUST follow the syntax guidelines.
#
# TaskList updates SHOULD be handled asynchronosly with `data-remote`.
# See: https://github.com/josh/rails-behaviors
#
# jQuery is required and the `$.pageUpdate` behavior MUST be available.
#
# ### Events
#
# When the TaskList field has been changed, a `tasklist:change` event is fired.
#
# Updating a task list item by clicking on the check box will send an
# `tasklist:updateSend` event. Following the `ajaxComplete` event,
# `tasklist:updateComplete` is triggered.
#
# ### NOTE
#
# Task list checkboxes are rendered as disabled by default because rendered
# user content is cached without regard for the viewer. We enable checkboxes
# on `pageUpdate` if the container has a `form.js-task-list-form`.

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
enableTaskList = ($container) ->
  if $container.find('.js-task-list-form').length > 0
    $container.
      find('.task-list-item').addClass('enabled').
      find('.task-list-item-checkbox').attr('disabled', null)
    $container.trigger 'tasklist:enabled'

disableTaskList = ($container) ->
  $container.
    find('.task-list-item').removeClass('enabled').
    find('.task-list-item-checkbox').attr('disabled', 'disabled')
  $container.trigger 'tasklist:disabled'

# Submit updates to task list items asynchronously.
# Successful updates won't require re-rendering to represent reality.
updateTaskList = ($item) ->
  $container = $item.closest '.js-task-list-container'
  $form      = $container.find '.js-task-list-form'
  $field     = $form.find '.js-task-list-field'
  index      = parseInt $item.attr('data-item-index')
  checked    = $item.prop 'checked'

  disableTaskList $container

  $field.val updateTaskListItem($field.val(), index, checked)
  $field.trigger 'change'
  $field.trigger 'tasklist:change', [index, checked]
  $form.trigger 'tasklist:updateSend', [index, checked]
  $form.one 'ajaxComplete', ->
    enableTaskList $container
    $form.trigger 'tasklist:updateComplete'
  $form.submit()

# When the task list item checkbox is updated, submit the change
$(document).on 'change', '.task-list-item-checkbox', ->
  updateTaskList $(this)

$.pageUpdate ->
  $('.js-task-list-container').each ->
    enableTaskList $(this)
