# TaskList Behavior
#
#= provides tasklist:enabled
#= provides tasklist:disabled
#= provides tasklist:change
#
#= require crema/events/pageupdate
#
# Enables Task List update behavior.
#
# ### Example Markup
#
#   <div class="js-task-list-container">
#     <ul class="task-list">
#       <li class="task-list-item">
#         <label>
#           <input type="checkbox" class="js-task-list-item-checkbox" disabled />
#           text
#         </label>
#       </li>
#     </ul>
#     <form>
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
# Task list items MUST match `(input).task-list-item-checkbox` and MUST be
# `disabled` by default. The Item's contents SHOULD be wrapped in a `LABEL`.
#
# TaskLists MUST have a `(textarea).js-task-list-field` form element whose
# `value` attribute is the source (Markdown) to be udpated. The source MUST
# follow the syntax guidelines.
#
# TaskList updates trigger `tasklist:change` events.
#
# jQuery is required and the `$.pageUpdate` behavior MUST be available.
#
# ### Events
#
# When the TaskList field has been changed, a `tasklist:change` event is fired.
#
# ### NOTE
#
# Task list checkboxes are rendered as disabled by default because rendered
# user content is cached without regard for the viewer. We enable checkboxes
# on `pageUpdate` if the container has a `(textarea).js-task-list-field`.

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

# Enables task list items to trigger updates.
enableTaskList = ($container) ->
  if $container.find('.js-task-list-field').length > 0
    $container.
      find('.task-list-item').addClass('enabled').
      find('.task-list-item-checkbox').attr('disabled', null)
    $container.trigger 'tasklist:enabled'

disableTaskList = ($container) ->
  $container.
    find('.task-list-item').removeClass('enabled').
    find('.task-list-item-checkbox').attr('disabled', 'disabled')
  $container.trigger 'tasklist:disabled'

# Updates the $field value to reflect the state of $item.
# Triggers the `tasklist:change` event when the value has changed.
updateTaskList = ($item) ->
  $container = $item.closest '.js-task-list-container'
  $field     = $container.find '.js-task-list-field'
  index      = 1 + $container.find('.task-list-item-checkbox').index($item)
  checked    = $item.prop 'checked'

  disableTaskList $container

  $field.val updateTaskListItem($field.val(), index, checked)
  $field.trigger 'change'
  $field.trigger 'tasklist:change', [index, checked]

# When the task list item checkbox is updated, submit the change
$(document).on 'change', '.task-list-item-checkbox', ->
  updateTaskList $(this)

$(document).on 'tasklist:disable', '.js-task-list-container', (event) ->
  disableTaskList $(this)

$(document).on 'tasklist:enable', '.js-task-list-container', (event) ->
  enableTaskList $(this)

$.pageUpdate ->
  $('.js-task-list-container').each ->
    $container = $(@)
    enableTaskList $container unless $container.hasClass 'js-task-list-disabled'
