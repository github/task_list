#= require task_list

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

    # non-breaking space. See: https://github.com/github/task-lists/pull/14
    @nbsp = String.fromCharCode(160)
    @incompleteNBSPItem = $ '<li>', class: 'task-list-item'
    @incompleteNBSPCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @blockquote = $ '<blockquote>'

    @quotedList = $ '<ul>', class: 'task-list'

    @quotedCompleteItem = $ '<li>', class: 'task-list-item'
    @quotedCompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: true

    @quotedIncompleteItem = $ '<li>', class: 'task-list-item'
    @quotedIncompleteCheckbox = $ '<input>',
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

    @orderedList = $ '<ol>', class: 'task-list'

    @orderedCompleteItem = $ '<li>', class: 'task-list-item'
    @orderedCompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: true

    @orderedIncompleteItem = $ '<li>', class: 'task-list-item'
    @orderedIncompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', text: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
    """

    @changes =
      toComplete: """
      - [ ] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toQuotedComplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [ ] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toInnerComplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [ ] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toOrderedComplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [ ] ordered complete
      > 0. [ ] ordered incomplete
      """
      toIncomplete: """
      - [x] complete
      - [x] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toQuotedIncomplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [x] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toInnerIncomplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [x] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toOrderedIncomplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [x] ordered incomplete
      """
      toIncompleteNBSP: """
      - [x] complete
      - [ ] incomplete
      - [x] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
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

    @quotedCompleteItem.append @quotedCompleteCheckbox
    @quotedList.append @quotedCompleteItem
    @quotedCompleteItem.expectedIndex = 4

    @quotedIncompleteItem.append @quotedIncompleteCheckbox
    @quotedList.append @quotedIncompleteItem
    @quotedIncompleteItem.expectedIndex = 5

    @blockquote.append @quotedList

    @innerCompleteItem.append @innerCompleteCheckbox
    @innerList.append @innerCompleteItem
    @innerCompleteItem.expectedIndex = 6

    @innerIncompleteItem.append @innerIncompleteCheckbox
    @innerList.append @innerIncompleteItem
    @innerIncompleteItem.expectedIndex = 7

    @innerBlockquote.append @innerList
    @innerBlockquote.append @innerField

    @blockquote.append @innerBlockquote

    @container.append @blockquote

    @orderedCompleteItem.append @orderedCompleteCheckbox
    @orderedList.append @orderedCompleteItem
    @orderedCompleteItem.expectedIndex = 8

    @orderedIncompleteItem.append @orderedIncompleteCheckbox
    @orderedList.append @orderedIncompleteItem
    @orderedIncompleteItem.expectedIndex = 9

    @container.append @orderedList

    @blockquote.append @field

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

# See: https://github.com/github/task-lists/pull/14
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

asyncTest "updates the source of a quoted item, marking the incomplete item as complete", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok checked
    equal index, @quotedIncompleteItem.expectedIndex
    equal @field.val(), @changes.toQuotedIncomplete

  setTimeout ->
    start()
  , 20

  @quotedIncompleteCheckbox.click()

asyncTest "updates the source of a quoted item, marking the complete item as incomplete", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok !checked
    equal index, @quotedCompleteItem.expectedIndex
    equal @field.val(), @changes.toQuotedComplete

  setTimeout ->
    start()
  , 20

  @quotedCompleteCheckbox.click()

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

asyncTest "updates the source of an ordered list item, marking the incomplete item as complete", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok checked
    equal index, @orderedIncompleteItem.expectedIndex
    equal @field.val(), @changes.toOrderedIncomplete

  setTimeout ->
    start()
  , 20

  @orderedIncompleteCheckbox.click()

asyncTest "updates the source of an ordered list item, marking the complete item as incomplete", ->
  expect 3

  @field.on 'tasklist:changed', (event, index, checked) =>
    ok !checked
    equal index, @orderedCompleteItem.expectedIndex
    equal @field.val(), @changes.toOrderedComplete

  setTimeout ->
    start()
  , 20

  @orderedCompleteCheckbox.click()

asyncTest "update ignores items that look like Task List items but lack list prefix", ->
  expect 3

  $('#qunit-fixture').empty()

  container = $ '<div>', class: 'js-task-list-container'

  list = $ '<ul>', class: 'task-list'

  item1 = $ '<li>', class: 'task-list-item'
  item1Checkbox = $ '<input>',
    type: 'checkbox'
    class: 'task-list-item-checkbox'
    disabled: true
    checked: false

  item2 = $ '<li>', class: 'task-list-item'
  item2Checkbox = $ '<input>',
    type: 'checkbox'
    class: 'task-list-item-checkbox'
    disabled: true
    checked: false

  field = $ '<textarea>', class: 'js-task-list-field', text: """
    [ ] one
    [ ] two
    - [ ] three
    - [ ] four
  """

  changes = """
    [ ] one
    [ ] two
    - [ ] three
    - [x] four
  """

  item1.append item1Checkbox
  list.append item1
  item1.expectedIndex = 1

  item2.append item2Checkbox
  list.append item2
  item2.expectedIndex = 2

  container.append list
  container.append field

  $('#qunit-fixture').append(container)
  container.taskList()

  field.on 'tasklist:changed', (event, index, checked) =>
    ok checked
    equal index, item2.expectedIndex
    equal field.val(), changes

  setTimeout ->
    start()
  , 20

  item2Checkbox.click()

asyncTest "update ignores items that look like Task List items but are links", ->
  expect 3

  $('#qunit-fixture').empty()

  container = $ '<div>', class: 'js-task-list-container'

  list = $ '<ul>', class: 'task-list'

  item1 = $ '<li>', class: 'task-list-item'
  item1Checkbox = $ '<input>',
    type: 'checkbox'
    class: 'task-list-item-checkbox'
    disabled: true
    checked: false

  item2 = $ '<li>', class: 'task-list-item'
  item2Checkbox = $ '<input>',
    type: 'checkbox'
    class: 'task-list-item-checkbox'
    disabled: true
    checked: false

  field = $ '<textarea>', class: 'js-task-list-field', text: """
    - [ ] (link)
    - [ ] [reference]
    - [ ] () collapsed
    - [ ] [] collapsed reference
    - [ ] \\(escaped item)
    - [ ] item
  """

  changes = """
    - [ ] (link)
    - [ ] [reference]
    - [ ] () collapsed
    - [ ] [] collapsed reference
    - [ ] \\(escaped item)
    - [x] item
  """

  item1.append item1Checkbox
  list.append item1
  item1.expectedIndex = 1

  item2.append item2Checkbox
  list.append item2
  item2.expectedIndex = 2

  container.append list
  container.append field

  $('#qunit-fixture').append(container)
  container.taskList()

  field.on 'tasklist:changed', (event, index, checked) =>
    ok checked
    equal index, item2.expectedIndex
    equal field.val(), changes

  setTimeout ->
    start()
  , 20

  item2Checkbox.click()

asyncTest "updates items followed by links", ->
  expect 3

  $('#qunit-fixture').empty()

  container = $ '<div>', class: 'js-task-list-container'

  list = $ '<ul>', class: 'task-list'

  item1 = $ '<li>', class: 'task-list-item'
  item1Checkbox = $ '<input>',
    type: 'checkbox'
    class: 'task-list-item-checkbox'
    disabled: true
    checked: false

  item2 = $ '<li>', class: 'task-list-item'
  item2Checkbox = $ '<input>',
    type: 'checkbox'
    class: 'task-list-item-checkbox'
    disabled: true
    checked: false

  field = $ '<textarea>', class: 'js-task-list-field', text: """
    - [ ] [link label](link)
    - [ ] [reference label][reference]
  """

  changes = """
    - [ ] [link label](link)
    - [x] [reference label][reference]
  """

  item1.append item1Checkbox
  list.append item1
  item1.expectedIndex = 1

  item2.append item2Checkbox
  list.append item2
  item2.expectedIndex = 2

  container.append list
  container.append field

  $('#qunit-fixture').append(container)
  container.taskList()

  field.on 'tasklist:changed', (event, index, checked) =>
    ok checked
    equal index, item2.expectedIndex
    equal field.val(), changes

  setTimeout ->
    start()
  , 20

  item2Checkbox.click()
