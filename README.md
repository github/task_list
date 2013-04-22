# Task Lists

This package provides various components necessary for integrating
[Task Lists](https://github.com/blog/1375-task-lists-in-gfm-issues-pulls-comments)
into your GitHub-flavored-Markdown user content.

## Components

The Task List feature is actually made of several different components:

* GitHub-flavored-Markdown Filter
* Model: summarizes and updates task list items
* Controller: provides the update interface (optional)
* JavaScript: enables task list behavior, handles AJAX updates, etc
* CSS: styles Markdown task list items

## Installation

Add this line to your application's Gemfile:

    gem 'task-lists'

And then execute:

    $ bundle

### Rails 3+: Rails Engine?

TBD

### Rails 2.3: Manual.

TBD

### CoffeeScript Requirements

The following Bower packages are required:

* jquery
* https://github.com/github/crema -- `$.pageUpdate`
* rails-behavior -- `data-remote`

## Usage

TBD

## Testing

To run the functional tests in the browser, install the necessary components:

```
bower install jquery
bower install https://github.com/github/crema.git
bower install rails-behavior
bundle install
```

Then run the server:

```
rackup -p 4011
```

Navigate to http://localhost:4011/test/functional/test_task_lists_behavior.html

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
