# Task Lists

This package provides various components necessary for integrating
[Task Lists](https://github.com/blog/1375-task-lists-in-gfm-issues-pulls-comments)
into your GitHub-flavored-Markdown user content.

## Components

The Task List feature is actually made of several different components:

* GitHub-flavored-Markdown Filter
* Model: summarizes task list items
* JavaScript: task list update behavior
* CSS: styles Markdown task list items

## Installation

Add this line to your application's Gemfile:

    gem 'task_list'

And then execute:

    $ bundle

### Rails 3+: Railtie method

``` ruby
# config/application.rb
require 'task_list/railtie'
```

### Rails 2.3: Manual method

Wherever you have your Sprockets setup:

``` ruby
Sprockets::Environment.new(Rails.root) do |env|
  # Load TaskList assets
  require 'task_list/railtie'
  TaskList.asset_paths.each do |path|
    env.append_path path
  end
end
```

If you're not using Sprockets, you're on your own but it's pretty straight
forward. `task_list/railtie` defines `TaskList.asset_paths` which you can use
to manage building your asset bundles.

### CoffeeScript Requirements

Aside from requiring CoffeeScript, jQuery is the only other requirement.

## Testing and Development

JavaScript unit tests can be run with `script/testsuite`.

Ruby unit tests can be run with `rake test`.

Functional tests are more for manual testing in the browser. To run, install
the necessary components with `script/bootstrap` then run the server:

```
rackup -p 4011
```

Navigate to http://localhost:4011/test/functional/test_task_lists_behavior.html

## Contributing

Read the [Contributing Guidelines] and open a Pull Request!
