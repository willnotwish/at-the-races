class MultiprocessDriver
  include AtrOne::Deps[:logger]
  include Tracing

  def call(updates:, processor:, thread_count: 2, **processor_opts)
    concurrency = thread_count # compatibility: needs removing
    trace "Starting. About to process #{updates.count} updates using #{concurrency} processes. Processor options: #{processor_opts}"

    concurrency.times do
      fork do
        process(updates: updates, processor: processor, **processor_opts)
      end
    end
    Process.waitall

    # Need this but not sure why (to do with forking I guess)
    ActiveRecord::Base.establish_connection

    trace 'Complete'
  end

  private

  def process(updates:, processor:, **processor_opts)
    updates.each do |update|
      trace "Processing update: #{update.id}. Value: #{update.value}"
      processor.call(update: update, **processor_opts)
    end
  end
end
