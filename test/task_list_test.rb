# encoding: utf-8
require File.expand_path('../test_helper', __FILE__)
require 'task_list'

class TaskListTest < Test::Unit::TestCase

  def test_updates_task_list_item_by_index
    text = <<-md
- [ ] index 1, incomplete
- [x] index 2, complete
    md

    assert_match "- [x] index 1, incomplete", update(text, 1, true).source
    assert_match "- [ ] index 2, complete", update(text, 2, false).source
  end

  def test_updates_task_lists_in_numbered_lists
    text = <<-md
1.  [ ] index 1, incomplete
14. [x] index 2, complete
    md

    assert_match "1.  [x] index 1, incomplete", update(text, 1, true).source
    assert_match "14. [ ] index 2, complete", update(text, 2, false).source
  end

  def test_updates_ignore_task_lists_in_code_fences
    text = <<-md
```
- [ ] should not be indexed
- [x] nor this
```

- [ ] index 1, incomplete
- [x] index 2, complete
    md

    assert_match "- [x] index 1, incomplete", update(text, 1, true).source
    assert_match "- [ ] index 2, complete", update(text, 2, false).source
  end

  def test_updates_ignores_items_in_paras
    text = <<-md
here's a paragraph:

[ ] should not be indexed
[x] nor this

- [ ] index 1, incomplete
- [x] index 2, complete
    md

    assert_match "- [x] index 1, incomplete", update(text, 1, true).source
    assert_match "- [ ] index 2, complete", update(text, 2, false).source
  end

  def test_update_cleans_carriage_returns_for_matches
    text = <<-md
``` markdown\r
- [ ] foo\r
```\r
\r
- [ ] index 1, incomplete\r
- [x] index 2, complete\r
    md

    assert_match "- [x] index 1, incomplete", update(text, 1, true).source
    assert_match "- [ ] index 2, complete", update(text, 2, false).source
  end

  def test_task_list_for_nil_body
    assert task_list(nil).items.empty?, "no task list items are expected"
  end

  def test_task_list_summary
    summary = task_list("").summary
    assert !summary.items?, "no task list items are expected"

    text = <<-md
- [ ] one
- [x] two

```
- [ ] don't count me yo
- [x] nor me
```
    md

    summary = task_list(text).summary
    assert summary.items?, "task list items are expected"
    assert_equal 2, summary.item_count
    assert_equal 1, summary.complete_count
    assert_equal 1, summary.incomplete_count
  end

  def task_list(text)
    TaskList.new(text)
  end

  def update(text, index, checked)
    task_list(text).update(index, checked)
  end
end
