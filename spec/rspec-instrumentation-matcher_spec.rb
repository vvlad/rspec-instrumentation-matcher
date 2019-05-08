require 'spec_helper'


describe RSpec::Instrumentation::Matcher do

  def event(notification, payload={})
    ActiveSupport::Notifications.instrument(notification, payload)
  end


  let(:notification) { 'a notification' }

  specify { expect { event(notification) }.to instrument(notification).once }
  specify { expect { 2.times { event(notification) } }.to instrument(notification).twice }
  specify { expect { 2.times { event(notification) } }.not_to instrument(notification).never }
  specify { expect { 2.times { event(notification) } }.to instrument(notification).at_least(1) }
  specify { expect { 2.times { event(notification) } }.to instrument(notification).at_most(2) }

  # test with
  specify { expect { event(notification, { test_payload: true }) }.to instrument(notification).with(test_payload: true) }
  specify { expect { event(notification, { test_payload: true }) }.to instrument(notification).with(anything) }
  specify { expect { event(notification) }.to instrument(notification).with(anything) }

  specify do
    expect {
      event(notification,{ test_payload: true, asd: true })
    }.to instrument(notification).with(hash_including(test_payload: true))
  end

  context 'when the instrumented block raises an exception' do
    it 'still unsubscribes the spy subscription' do
      notifier = ActiveSupport::Notifications.notifier
      expect {
        begin
          expect {
            ActiveSupport::Notifications.instrument(notification) do
              raise ZeroDivisionError
            end
          }.to instrument(notification)
        rescue ZeroDivisionError
        end
      }.not_to change { notifier.listeners_for(notification).length }
    end
  end
end
