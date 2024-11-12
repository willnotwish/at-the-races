class MultiprocessDriver
  include AtrOne::Deps[:logger]
  include Tracing

  include AtrOne::Deps[:message_bus]

  def call(updates:, processor:, thread_count: 2, **processor_opts)
    # thread_count should really be called process_count
    process_count = thread_count

    trace "Starting. About to process #{updates.count} updates using #{process_count} processes. Processor options: #{processor_opts}"

    # Fork a new process for each group so they are processed concurrently
    groups = {}
    updates.in_groups(process_count, false).each do |group|
      pid = fork do
        process(updates: group, processor: processor, **processor_opts)
      end
      groups[pid.to_s] = group
    end
    Process.waitall # wait for the forked processes to finish before continuing

    # Need this but not sure why (to do with forking I guess)
    ActiveRecord::Base.establish_connection

    trace 'Complete'
    groups
  end

  private

  def process(updates:, processor:, **processor_opts)
    message_bus.publish('driver.start', text: "driver started")

    updates.each do |update|
      trace "Processing update: #{update.id}. Value: #{update.value}"
      processor.call(update: update, **processor_opts)
    end

    message_bus.publish('driver.stop', text: "driver stop")
  end
end
