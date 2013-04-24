#= require task_lists

module "TaskLists",
  setup: ->
    window.linkActivated = false

    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'
    @item = $ '<li>', class: 'task-list-item'
    @checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: 'disabled'
      "data-item-index": 1

    @field = $ '<textarea>', class: 'js-task-list-field', "- [ ] text"

    @item.append @checkbox
    @list.append @item
    @container.append @list

    @container.append @field

    $('#qunit-fixture').append(@container).pageUpdate()

  teardown: ->

asyncTest "triggers a tasklist:change event on task list item changes", ->
  expect 1

  @field.on 'tasklist:change', (event, index, checked) ->
    ok true

  setTimeout ->
    start()
  , 20

  @checkbox.click()
