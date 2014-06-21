#= require task_list

module "TaskList events",
  setup: ->
    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'
    @item = $ '<li>', class: 'task-list-item'
    @checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', "- [ ] text"

    @item.append @checkbox
    @list.append @item
    @container.append @list

    @container.append @field

    $('#qunit-fixture').append(@container)
    @container.taskList()

  teardown: ->
    $(document).off 'tasklist:enabled'
    $(document).off 'tasklist:disabled'
    $(document).off 'tasklist:change'
    $(document).off 'tasklist:changed'

asyncTest "triggers a tasklist:change event before making task list item changes", ->
  expect 1

  @field.on 'tasklist:change', (event, index, checked) ->
    ok true

  setTimeout ->
    start()
  , 20

  @checkbox.click()

asyncTest "triggers a tasklist:changed event once a task list item changes", ->
  expect 1

  @field.on 'tasklist:changed', (event, index, checked) ->
    ok true

  setTimeout ->
    start()
  , 20

  @checkbox.click()

asyncTest "can cancel a tasklist:changed event", ->
  expect 2

  @field.on 'tasklist:change', (event, index, checked) ->
    ok true
    event.preventDefault()

  @field.on 'tasklist:changed', (event, index, checked) ->
    ok false

  before = @checkbox.val()
  setTimeout =>
    equal before, @checkbox.val()
    start()
  , 20

  @checkbox.click()

asyncTest "enables task list items when a .js-task-list-field is present", ->
  expect 1

  $(document).on 'tasklist:enabled', (event) ->
    ok true

  @container.taskList()
  setTimeout ->
    start()
  , 20

asyncTest "doesn't enable task list items when a .js-task-list-field is absent", ->
  expect 0

  $(document).on 'tasklist:enabled', (event) ->
    ok true

  @field.remove()

  @container.taskList()
  setTimeout ->
    start()
  , 20
