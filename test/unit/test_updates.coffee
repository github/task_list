#= require task_lists

module "TaskList updates",
  setup: ->
    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'

    @completeItem = $ '<li>', class: 'task-list-item'
    @completeCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: true

    @incompleteItem = $ '<li>', class: 'task-list-item'
    @incompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @incompleteNBSPItem = $ '<li>', class: 'task-list-item'
    @incompleteNBSPCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', text: """
      - [x] complete
      - [ ] incomplete
      - [\xC2\xA0] incompleteNBSP
    """

    @changes =
      toComplete: """
      - [ ] complete
      - [ ] incomplete
      - [\xC2\xA0] incompleteNBSP
      """
      toIncomplete: """
      - [x] complete
      - [x] incomplete
      - [\xC2\xA0] incompleteNBSP
      """
      toIncompleteNBSP: """
      - [x] complete
      - [ ] incomplete
      - [x] incompleteNBSP
      """

    @completeItem.append @completeCheckbox
    @list.append @completeItem
    @completeItem.expectedIndex = 1

    @incompleteItem.append @incompleteCheckbox
    @list.append @incompleteItem
    @incompleteItem.expectedIndex = 2

    @incompleteNBSPItem.append @incompleteNBSPCheckbox
    @list.append @incompleteNBSPItem
    @incompleteNBSPItem.expectedIndex = 3

    @container.append @list
    @container.append @field

    $('#qunit-fixture').append(@container)
    @container.taskList()

  teardown: ->
    $(document).off 'tasklist:changed'

asyncTest "updates the source, marking the incomplete item as complete", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok checked
    equal index, @incompleteItem.expectedIndex
    equal @field.val(), @changes.toIncomplete

  setTimeout ->
    start()
  , 20

  @incompleteCheckbox.click()

asyncTest "updates the source, marking the complete item as incomplete", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok !checked
    equal index, @completeItem.expectedIndex
    equal @field.val(), @changes.toComplete

  setTimeout ->
    start()
  , 20

  @completeCheckbox.click()

asyncTest "updates the source for items with non-breaking spaces", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok checked
    equal index, @incompleteNBSPItem.expectedIndex
    equal @field.val(), @changes.toIncompleteNBSP

  setTimeout ->
    start()
  , 20

  @incompleteNBSPCheckbox.click()
