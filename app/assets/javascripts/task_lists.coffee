# Task list checkboxes are rendered as disabled by default
# because rendered user content is cached without regard
# for the viewer. Enables the checkboxes and applies the
# correct list style, if the viewer is able to edit the comment.
enableTaskList = (comment) ->
  if comment.find('.js-comment-edit-button').length > 0
    comment.addClass('context-loader-container')
    comment.find('.js-comment-body').addClass('context-loader-overlay')
    comment.
      find('.task-list-item').addClass('enabled').
      find('.task-list-item-checkbox').attr('disabled', null)
    comment.closest('.context-loader-container').find('.context-loader:first').
      removeClass 'is-context-loading'

disableTaskList = (comment) ->
  comment.
    find('.task-list-item').removeClass('enabled').
    find('.task-list-item-checkbox').attr('disabled', 'disabled')
  comment.closest('.context-loader-container').find('.context-loader:first').
    addClass 'is-context-loading'

# Submit updates to task list items asynchronously.
# Successful updates won't require re-rendering to represent reality.
updateTaskListItem = (item) ->
  comment = item.parents('.js-comment')
  form    = comment.find('form.js-comment-update')
  body    = comment.find('.js-comment-body')
  data =
    item:     item.attr('data-item-index')
    checked:  if item.prop('checked') then 1 else 0
    body_version: body.attr('data-body-version')

  disableTaskList(comment)

  $.ajax
    type: 'post'
    url: form.attr('action')+'/task'
    data: data
    dataType: 'json'
    success: (data) ->
      console.log 'success', data
      if data.stale
        window.location.href = window.location.href
      else
        body.attr('data-body-version', data.new_body_version)
        comment.find('.form-content .js-comment-field').val(data.new_body)
    error: (e) ->
      console.log 'error', e
    complete: ->
      enableTaskList(comment)

# When the task list item checkbox is updated, submit the change
$(document).on 'change', 'input.task-list-item-checkbox[type=checkbox]', ->
  updateTaskListItem $(this)

$.pageUpdate ->
  $('.js-comment').each ->
    enableTaskList($(this))
