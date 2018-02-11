# Dirable

Dirable provides an interface for creating object hierarchies and persisting them to the filesystem. It's kinda like ActiveRecord, without the SQL database!

## Usage

Create a new object hierarchy:
```ruby
class RunningLog < Dirable::Record
  def initialize(*)
    super
    has_one('goal', Goal)
    has_many('runs', Run)
  end
end

class Goal < Dirable::Record
  def initialize(*)
    super
    has_attribute('race')
    has_attribute('date')
    has_attribute('time')
  end
end

class Run < Dirable::Record
  def initialize(*)
    super
    has_attribute('distance')
    has_attribute('time')
    has_attribute('notes')
  end
end
```

Configure the root directory and class name:

```ruby
Dirable.configure do |config|
  config.root_dir = '/tmp/running_log'
  config.root_class = RunningLog
end
```

Add and delete from many relations:
```ruby
Dirable.root.runs.add('Tempo Tuesday')
Dirable.root.runs.delete('Tempo Tuesday')
```

Access a many relation and set attributes:
```ruby
Dirable.root.runs['Tempo Tuesday'].distance = '10 miles'
Dirable.root.runs['Tempo Tuesday'].time = '1 hour'
Dirable.root.runs['Tempo Tuesday'].notes = 'Cruising!'
```

Access a one relation and set attributes:
```ruby
Dirable.root.goal.race = 'Boston Marathon'
Dirable.root.goal.date = 'April, 16th 2018'
Dirable.root.goal.time = '3 hours'
```

Everything is persisted to a directory hierarchy and Dirable will automatically pick up any updates you make to it!
```
mkdir '/tmp/running_log/runs/Long Run Sunday'
echo '16 miles' >> '/tmp/running_log/runs/Long Run Sunday/distance'
```

```ruby
Dirable.root.runs['Long Run Sunday'].distance
# 16 miles
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

