class DatabaseLockingProcessor
  include AtrOne::Deps[:logger]

  class NotifyingImplementation
    include Tracing

    include MysqlLock
  
    attr_reader :monitor, :logger

    def initialize(monitor:, logger:, **)
      @monitor = monitor
      @logger = logger
    end

    def notify(*args)
      monitor.call(*args)
    end

    def call(update:, **opts)
      raise ArgumentError, 'update parameter must be specified' unless update

      trace "#call starting..."

      month = Month.find_by!(code: update.month_code)

      update.allocate!
      notify('update.allocated', text: "update #{update.id} allocated")

      # There is a possible race condition between querying for an existing counter and creating a new one.
      # 
      # After process/thread A has failed to find a counter with the given code for the given month,
      # but before it has a chance to create a new one, process/thread B runs. Detecting no counter,
      # B creates a new one. A then runs, creating a second, duplicate counter.
      # 
      # This condition may be detected by specifying a uniqueness database constraint on the counter:
      # no two counters for the same month may exist with the same name.
      # 
      # An alternative is to require a global (database-wide) lock before proceeding through this "critical section"
      # of the code, like this:
      lock_name = "#{update.counter_code}__#{month.code}"
      with_mysql_lock(name: lock_name, **opts) do
        logger.tagged "LOCKED: #{lock_name}" do
          perform_counter_update!(update: update, month: month, **opts)
        end
      end

      trace '#call. Done'
    end

    private
  
    def perform_counter_update!(update:, month:, **opts)
      # In production, do it like this
      # counter = Counter.find_or_create_by!(code: update.counter_code, month: month)
      # 
      # In Rails 4.2, this is equivalent to:
      # 
      # def find_or_create_by!(attributes, &block)
      #   find_by(attributes) || create!(attributes, &block)
      # end
  
      # In general, the less time spent inside the critical section (between the SELECT and INSERT), the better.
      # In this case, however, we add a deliberate delay in order to make the race condition more likely
      attrs = { code: update.counter_code, month: month }
  
      counter = Counter.find_by(attrs)
      if counter
        trace 'Counter already exists'
      else
        delay(**opts)
        counter = Counter.create!(attrs)
        trace "Created counter #{counter.code} for month #{month.code}"
      end
  
      counter.update!(value: update.value)
      update.process! # marks update as processed
      notify('update.processed', text: "update #{update.id} processed")
  
      trace "Updated counter #{counter.code}. Value: #{counter.value}"
    end
  
    def delay(race_delay: nil, **)
      return unless race_delay.present?
  
      trace "Delaying for #{race_delay} seconds"
      notify('race_delay.starting', text: "Delay for #{race_delay} seconds. Starting...")
  
      sleep(race_delay)
  
      notify('race_delay.ended', text: "Delay for #{race_delay} seconds. Over.")
      trace 'Delay over'
    end
  end

  def call(update:, monitor:, **opts)
    NotifyingImplementation.new(monitor: monitor, logger: logger)
                           .call(update: update, **opts)
  end
end
