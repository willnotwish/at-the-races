class DatabaseLockingProcessor
  include AtrOne::Deps[:logger]
  include Tracing
  
  def call(update:, **opts)
    trace "Starting. options: #{opts}"
    raise ArgumentError, 'update parameter must be specified' unless update
    
    month = Month.find_by!(code: update.month_code)
    trace "Month: #{month.code}"

    # There is a possibile race condition between querying for an existing counter
    # and creating a new one.
    # 
    # After process/thread A has failed to find a counter with the given code for the given month,
    # but befire it has a chance to create a new one, process/thread B runs. Detecting no counter,
    # B creates a new one. A then runs, creating a second, duplicate counter.
    # 
    # This condition may be detected by specifying a uniqueness database constraint on the counter:
    # no two counters for the same month may exist with the same name.
    # 
    # An alternative is to require a global (database-wide) lock before proceeding through this "critical section"
    # of the code, like this:
    lock_name = "#{update.counter_code}__#{month.code}"
    with_global_lock(name: lock_name, **opts) do
      logger.tagged "LOCKED: #{lock_name}" do
        process_counter_update!(update: update, month: month, **opts)
      end
    end

    trace 'Done'
  end

  private

  def process_counter_update!(update:, month:, **opts)
    # In production, do it like this
    # counter = Counter.find_or_create_by!(code: update.counter_code, month: month)
    # 
    # In Rails 4.2, this is equivalent to:
    # 
    # def find_or_create_by!(attributes, &block)
    #   find_by(attributes) || create!(attributes, &block)
    # end

    # In general, the less time spent inside the critical section, the better. However, we add
    # a delay here (between the SELECT and INSERT) in order to make the race condition more likely
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
    trace "Updated counter #{counter.code}. Value: #{counter.value}"
  end

  def delay(race_delay: nil, **)
    return unless race_delay.present?

    trace "Delaying for #{race_delay} seconds"
    sleep(race_delay)
    trace 'Delay over'
  end

  def with_global_lock(**opts)
    return unless obtain_lock(**opts)
    
    begin
      yield
    ensure
      release_lock(**opts)
    end
  end

  # Tries to obtain a lock with the given name, using a timeout of timeout seconds. A negative timeout value means infinite timeout.
  def obtain_lock(name:, lock_timeout: 5, **)
    # GET_LOCK returns 1 if the lock was obtained successfully, 0 if the attempt timed out (for example, because another client has previously locked the name),
    # or NULL if an error occurred (such as running out of memory or the thread was killed with mysqladmin kill).
    case execute_raw_sql("SELECT GET_LOCK('#{name}', #{lock_timeout});")
    when 0
      trace "Failed to obtain lock #{name}. Timed out after #{lock_timeout} seconds"
      false
    when 1
      trace 'Lock obtained'
      true
    else
      trace 'Error occurred when attempting to obtain lock'
      false
    end
  end

  def release_lock(name:, **)
    case execute_raw_sql("SELECT RELEASE_LOCK('#{name}');")
    when 0
      trace "Failed to release lock: #{name}. Lock was not established by this thread."
      false
    when 1
      trace 'Lock released'
      true
    else
      trace 'Named lock does not exist'
      false
    end
  end

  def execute_raw_sql(statement)
    result = ActiveRecord::Base.connection.exec_query(statement)
    raise 'Unexpected SQL query result' unless result.length == 1

    result.rows.first.first
  end
end
