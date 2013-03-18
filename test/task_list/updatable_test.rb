require File.expand_path('../../test_helper', __FILE__)
require 'task_list/updatable'

class UpdatableContent
  include TaskList::Updatable

  attr_accessor :body, :events, :subscribed_event

  def initialize(body)
    @body = body
    @events = []
  end

  def instrument(event, payload)
    if "#{instrument_task_list_update_key}.#{event}" == subscribed_event
      events << [event, payload]
    end
  end
  def subscribe(event, events)
    self.subscribed_event = event
    self.events = events
    events
  end

  def update_attributes!(opts)
    self.body = opts[:body]
  end

  def self.name
    s = "UpdatableContent"
    def s.underscore
      "updatable_content"
    end
    s
  end
end

class TaskList::UpdatableTest < Test::Unit::TestCase
  def setup
    @checked    = 1
    @incomplete = "- [ ] test"
    @complete   = "- [x] test"

    @model = UpdatableContent.new(@incomplete)
  end

  def test_updates_the_body
    @model.update_task_list 1, @checked
    assert_equal @complete, @model.body
  end

  def test_instruments_changes
    events = subscribe "updatable_content.update_task_list"
    @model.update_task_list(item = 1, @checked)
    event, payload = events.pop
    assert event, "event expected"
    assert_equal 'updatable_content', payload[:class_key]
    assert_equal @checked, payload[:checked]
  end

  protected

  def subscribe(event, events = [])
    @model.subscribe(event, events)
    events
  end
end
