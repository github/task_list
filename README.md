# Task Lists

This package provides various components necessary for integrating
[Task Lists](https://github.com/blog/1375-task-lists-in-gfm-issues-pulls-comments)
into your GitHub-flavored-Markdown user content.

## Components

The Task List feature is actually made of several different components:

* GitHub-flavored-Markdown Ruby Filter
* Summary Ruby Model: summarizes task list items
* JavaScript: frontend task list update behavior
* CSS: styles Markdown task list items

## Installation

Task Lists are packaged as both a RubyGem with both backend and frontend behavior, and a Bower package wiht just the frontend behavior.

### Backend: RubyGem

For the backend Ruby components, add this line to your application's Gemfile:

    gem 'task_list'

And then execute:

    $ bundle

### Frontend: Bower

For the frontend components, add `task_list` to your Bower dependencies config.

This is the preferred method for including the frontend assets in your application. Alternatively, for Rails methods using `Sprockets`, see below.

### Frontend: Rails 3+ Railtie method

``` ruby
# config/application.rb
require 'task_list/railtie'
```

### Frontend: Rails 2.3 Manual method

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

### Dependencies

At a high level, the Ruby components integrate with the [`html-pipeline`](https://github.com/jch/html-pipeline) library, and the frontend components depend on the jQuery library. The frontend components are written in CoffeeScript and need to be preprocessed for production use.

## Testing and Development

JavaScript unit tests can be run with `script/testsuite`.

Ruby unit tests can be run with `rake test`.

Functional tests are useful for manual testing in the browser. To run, install
the necessary components with `script/bootstrap` then run the server:

```
rackup -p 4011
```

Navigate to http://localhost:4011/test/functional/test_task_lists_behavior.html

## Contributing

Read the [Contributing Guidelines](CONTRIBUTING.md) and open a Pull Request!
