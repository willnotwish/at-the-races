require 'tracing'

class MultiprocessDriver
  include AtrOne::Deps[:logger]
  include Tracing

  # include AtrOne::Deps[:message_bus]

  # class RaceEventPublisher
  #   extend Dry::Initializer

  #   param :message_bus
  #   param :race

  #   def call(id, payload)
  #     message_bus.publish(id, payload.merge(race_id: race.id))
  #   end
  # end

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
    notify_groups(groups, **processor_opts)
    
    Process.waitall # wait for the forked processes to finish before continuing

    # Need this but not sure why (to do with forking I guess)
    ActiveRecord::Base.establish_connection

    trace 'Complete'
    groups
  end

  private

  def process(updates:, processor:, monitor:, **processor_opts)
    monitor.call('driver.start', text: "driver started")

    updates.each do |update|
      trace "Processing update: #{update.id}. Value: #{update.value}"
      processor.call(update: update, monitor: monitor, **processor_opts)
    end

    monitor.call('driver.stop', text: "driver stop")
  end

  def notify_groups(groups, monitor:, **)
    monitor.call('groups.defined', text: "groups defined", groups: groups.keys)
  end
end
