RAILS_ROOT = "/home/woto/rails/avtorif"
RAILS_ENV = "development"

5.times do |num|
  God.watch do |w|
    w.env = {
       'RAILS_ROOT' => "#{RAILS_ROOT}",
       'RAILS_ENV' => "#{RAILS_ENV}" 
    }
    w.name = "dj-#{num}"
    w.group = 'dj'
    w.interval = 30.seconds
    w.start = "rake -f #{RAILS_ROOT}/Rakefile jobs:work"
    w.log = "#{RAILS_ROOT}/log/dj-#{num}.log"
    w.err_log = "#{RAILS_ROOT}/log/dj-#{num}.err.log"

    w.uid = 'woto'
    w.gid = 'users'

    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 300.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
	c.notify = 'webmaster'
      end
    end
 
    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end
 
      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end
 
    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
	c.notify = 'webmaster'
      end
    end
  end
end
