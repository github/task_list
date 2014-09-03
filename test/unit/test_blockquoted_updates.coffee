#= require task_list

module "Blockquoted TaskList updates",
  setup: ->
    @container = $ '<div>', class: 'js-task-list-container'
      
    @blockquote = $ '<blockquote>'

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
      
    @innerBlockquote = $ '<blockquote>'

    @innerList = $ '<ul>', class: 'task-list'

    @innerCompleteItem = $ '<li>', class: 'task-list-item'
    @innerCompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: true

    @innerIncompleteItem = $ '<li>', class: 'task-list-item'
    @innerIncompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', text: """
      > - [x] complete
      > - [ ] incomplete
      > > - [x] inner complete
      > > - [ ] inner incomplete
    """

    @changes =
      toComplete: """
      > - [ ] complete
      > - [ ] incomplete
      > > - [x] inner complete
      > > - [ ] inner incomplete
      """
      toIncomplete: """
      > - [x] complete
      > - [x] incomplete
      > > - [x] inner complete
      > > - [ ] inner incomplete
      """
      toInnerComplete: """
      > - [x] complete
      > - [ ] incomplete
      > > - [ ] inner complete
      > > - [ ] inner incomplete
      """
      toInnerIncomplete: """
      > - [x] complete
      > - [ ] incomplete
      > > - [x] inner complete
      > > - [x] inner incomplete
      """

    @completeItem.append @completeCheckbox
    @list.append @completeItem
    @completeItem.expectedIndex = 1

    @incompleteItem.append @incompleteCheckbox
    @list.append @incompleteItem
    @incompleteItem.expectedIndex = 2

    @blockquote.append @list
    @blockquote.append @field

    @innerCompleteItem.append @innerCompleteCheckbox
    @innerList.append @innerCompleteItem
    @innerCompleteItem.expectedIndex = 3

    @innerIncompleteItem.append @innerIncompleteCheckbox
    @innerList.append @innerIncompleteItem
    @innerIncompleteItem.expectedIndex = 4

    @innerBlockquote.append @innerList
    @innerBlockquote.append @innerField

    @blockquote.append @innerBlockquote

    @container.append @blockquote 
    
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

asyncTest "updates the source of a quoted quoted item, marking the incomplete item as complete", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok checked
    equal index, @innerIncompleteItem.expectedIndex
    equal @field.val(), @changes.toInnerIncomplete

  setTimeout ->
    start()
  , 20

  @innerIncompleteCheckbox.click()

asyncTest "updates the source of a quoted quoted item, marking the complete item as incomplete", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok !checked
    equal index, @innerCompleteItem.expectedIndex
    equal @field.val(), @changes.toInnerComplete

  setTimeout ->
    start()
  , 20

  @innerCompleteCheckbox.click()
