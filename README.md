rspec-instrumentation-matcher
=============================


## Installation

Add this line to your application's Gemfile:

    gem 'rspec-instrumentation-matcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-instrumentation-matcher

## Usage

    expect{ subject.do_something }.to instrument("key").with( foo: :bar )
    expect{ subject.do_something }.to instrument("key").once
    expect{ subject.do_something }.to instrument("key").never
    expect{ subject.do_something }.to instrument("key").at_least(1)
    expect{ subject.do_something }.to instrument("key").at_most(10)
    expect{ subject.do_something }.to instrument("key").times(5)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
