require "rspec-instrumentation-matcher/version"

module RSpec
  module Instrumentation
    module Matcher
      def instrument(subject)
        InstrumentMatcher.new(subject)
      end
      class InstrumentMatcher

        def initialize(subject)
          @subject = subject
          @payload = nil
          @received = 0
          @at_least = 1
        end

        def matches?(event_proc)
          raise_block_syntax_error if block_given?

          subscription = ActiveSupport::Notifications.subscribe @subject do |name, start, finish, id, _payload|
            @payload = _payload
            @received += 1
          end

          event_proc.call

          ActiveSupport::Notifications.unsubscribe(subscription)

          times? and at_least? and at_most? and with?

        end

        def failure_message
          message = "Expected #{@subject} to be instrumented"
          message << " at least #{count @at_least}" unless at_least?
          message << " at most #{count @at_most}" unless at_most?
          message << " exactly #{count @times}" unless times?

          if !at_least? or !at_most? or !times?
            message << " but was instrumented #{count @received}"
            message << " and the payload should have been" unless with?
          else
            message << " with" unless with?
          end

          message << " #{@payload_expectation.inspect} instead of #{@payload.inspect}" unless with?


          message

        end

        def at_least(value)
          @at_least=value
          self
        end

        def at_most(value)
          @at_most = value
          self
        end

        def once
          times(1)
        end

        def never
          times(0)
        end



        def times(value)
          @times = value
          self
        end


        def with(expectation)
          @with = true
          @payload_expectation = expectation
          self
        end


        private
        def count(value)
          if value == 1
            "1 time"
          else
            "#{value} times"
          end
        end

        def at_least?
          return true unless @at_least
          @received <= @at_least
        end

        def at_most?
          return true unless @at_most
          @received >= @at_most
        end

        def times?
          return true unless @times
          @received == @times
        end

        def delta_payload
          unmatched = @payload_expectation.reject do |key,value|
            matched_value?(value, @payload[key]) if @payload.key? key
          end
        end

        def with?
          return true unless @with
          !@payload.nil? and delta_payload.size == 0
        end


        def matched_value?(expected, actual)
          case expected
          when actual then true
          when Class then actual.is_a? expected
          when Regexp then actual =~ expected
          else false
          end
        end


      end
    end
  end
end

module RSpec::Matchers
  include RSpec::Instrumentation::Matcher
end


