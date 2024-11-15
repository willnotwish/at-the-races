module MysqlLock
  extend ActiveSupport::Concern

  def with_mysql_lock(**opts)
    raise ArgumentError, 'Missing block' unless block_given?   
    return unless obtain_mysql_lock(**opts)
    
    monitor.call('lock.acquired', text: "Lock acquired.")
    
    begin
      yield
    ensure
      release_mysql_lock(**opts)
      monitor.call('lock.released', text: "Lock released.")
    end
  end

  # Tries to obtain a lock with the given name, using a timeout of timeout seconds. A negative timeout value means infinite timeout.
  def obtain_mysql_lock(name:, lock_timeout: 10, **)
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

  def release_mysql_lock(name:, **)
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
