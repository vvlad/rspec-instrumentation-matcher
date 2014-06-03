require 'spec_helper'


describe RSpec::Instrumentation::Matcher do

  def event(notification, payload={})
    ActiveSupport::Notifications.instrument(notification, payload)
  end


  let(:notification) { 'a notification' }

  specify { expect { event(notification) }.to instrument(notification).once }
  specify { expect { 2.times { event(notification) } }.not_to instrument(notification).never }
  specify { expect { 2.times { event(notification) } }.to instrument(notification).at_least(1) }
  specify { expect { 2.times { event(notification) } }.to instrument(notification).at_most(2) }
  specify { expect { event(notification,{ test_payload: true }) }.to instrument(notification).with(test_payload: true) }


end
