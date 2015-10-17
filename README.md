# Migratiq

Migrate your scheduled sidekiq jobs when their arguements change. :tada:

After a deploy, if the number of arguements on a worker has changed
those workers tend to fail unless you delete them manually
now you can either specify a migration plan for a particular number of arguments
i.e.

```Ruby
class HardWorker
  include Migratiq

  def perform(a, b)
    # Do work here...
  end

  migrate_by(arity: 5) do |a, b, c, d, e|
    [b, a]
  end
end

pry> HardWorker.migrate!
```

or remove all jobs that don't match the current interface

```Ruby
class HardWorker
  include Migratiq

  def perform(a, b)
    # Do work here...
  end
end

pry> HardWorker.migrate!(delete: true)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'migratiq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install migratiq

## Usage

Say your current worker looks something like,

```Ruby
class HardWorker
  def perform(a, b, c, d)
    # Do work here...
  end
end
```

and you find that you no longer need to take arguments `c` and `d`. So now your worker looks like,

```Ruby
class HardWorker
  def perform(a, b)
    # Do work here...
  end
end
```

Now if you deploy this change and `HardWorker` has work that is already scheduled, **all those jobs will fail**.

if you aren't concerned about loosing that work, all you need to do is add migratiq and you can remove them all and clean up your logs

```Ruby
class HardWorker
  include 'migratiq'
  def perform(a, b)
    # Do work here...
  end
end

pry>HardWorker.migrate!(delete: true)
```

It will remove all the jobs that do not match the current arity of the perform function.
However, if you don't want to loose your work, you can tell Migratiq how to migrate the worker params

```Ruby
class HardWorker
  include Migratiq

  def perform(a, b)

  end

  migrate_by(arity: 4) do |a, b, c, d|
    [b, a]
  end
end

pry> HardWorker.migrate!
```

This work will be rescheduled with the new arguements. if you also want to delete the old jobs you can add the `delete: true` flag on migrate.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/migratiq.
