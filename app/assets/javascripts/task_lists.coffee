# Enables Task List update behavior.
#
# Expects:
#
# A containing `div.js-task-list-container` with these attributes:
# * `data-task-list-update-url` with the URL to update contained items
# * `data-version` with the current version of the content
#
# Task list items should match `input.task-list-item-checkbox[type=checkbox]`.
#
# Events:
#
# When an update succeeds, a `updated.taskList' event is triggered, passing
# along whatever data the request responded with. Handle this event if you
# need additional behavior.
#
# Setup:
#
# Task list checkboxes are rendered as disabled by default because rendered
# user content is cached without regard for the viewer. We enable checkboxes
# on `pageUpdate` if the container has the `data-task-list-update-url`
# attribute set.

enableTaskList = (container) ->
  if container.attr('data-task-list-update-url').length > 0
    container.addClass('context-loader-container')
    unless container.find('.context-loader-overlay').addBack('.context-loader-overlay').length
      container.addClass('context-loader-overlay')
    container.
      find('.task-list-item').addClass('enabled').
      find('.task-list-item-checkbox').attr('disabled', null)
    container.closest('.context-loader-container').find('.context-loader:first').
      removeClass 'is-context-loading'

disableTaskList = (container) ->
  container.
    find('.task-list-item').removeClass('enabled').
    find('.task-list-item-checkbox').attr('disabled', 'disabled')
  container.closest('.context-loader-container').find('.context-loader:first').
    addClass 'is-context-loading'

# Submit updates to task list items asynchronously.
# Successful updates won't require re-rendering to represent reality.
#
# If the response from the server includes `stale: true`, we reload the page
# since the user is trying to update old data. An error should be displayed
# when the page loads. In Rails, you can use `flash[:error]`.
updateTaskListItem = (item) ->
  container = item.closest('.js-task-list-container')
  url  = container.attr('data-task-list-update-url')
  data =
    item:    item.attr('data-item-index')
    checked: if item.prop('checked') then 1 else 0
    version: container.attr('data-version')

  disableTaskList(container)

  $.ajax
    type: 'post'
    url: url
    data: data
    dataType: 'json'
    success: (data) ->
      if data.stale
        window.location.href = window.location.href
      else
        container.attr('data-version', data.new_version)
        container.trigger('updated.task-list', data)
    error: (e) ->
      console.log 'error', e
    complete: ->
      enableTaskList(container)

# When the task list item checkbox is updated, submit the change.
$(document).on 'change', 'input.task-list-item-checkbox[type=checkbox]', ->
  updateTaskListItem($(this))

$.pageUpdate ->
  $('.js-task-list-container').each ->
    enableTaskList($(this))
