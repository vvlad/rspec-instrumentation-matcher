require "rspec-instrumentation-matcher/version"

module Rspec
  module Instrumentation
    module Matcher
    end
  end
end

RSpec::Matchers.define :instrument do |notification|

  match do |event_proc|
    raise_block_syntax_error if block_given?

    @payload = nil
    @received = 0
    subscription = ActiveSupport::Notifications.subscribe notification do |name, start, finish, id, _payload|
      @payload = _payload
      @received += 1
    end

    event_proc.call

    ActiveSupport::Notifications.unsubscribe(subscription)

    received? and matches_payload? and right_times?

  end

  def at_least(value)
    @at_least=true
    times(value)
  end

  def at_most(value)
    @at_most = true
    times(value)
  end

  def once
    at_least(1).at_most(1)
  end


  def times(value)
    @times = value
    self
  end

  def received?
    @received > 0
  end

  def right_times?
    true unless @times
    success = @at_least ? @received <= @times : true
    success = @at_most ? @received >= @times : success
    success
  end

  def with(expectation)
    @with = true
    @payload_expectation = expectation
    self
  end


  def matches_payload?
    unmatched = @payload_expectation.reject do |key,value|
      matched_value?(value, @payload[key]) if @payload.key? key
    end
    unmatched.size == 0
  end


  def matched_value?(expected, actual)
    return true if !@with or expected == actual
    case expected
    when Class then actual.is_a? expected
    when Regexp then actual =~ expected
    else
      false
    end
  end

end
