class MultithreadedDriver
  include AtrOne::Deps[:logger]
  include Tracing

  def call(updates:, processor:, thread_count: 2, **processor_opts)
    trace "Starting. About to process #{updates.count} updates using #{thread_count} threads. Processor options: #{processor_opts}"

    worker_threads = []
    thread_count.times do
      worker_threads << Thread.new do 
        process(updates: updates, processor: processor, **processor_opts)
      end
    end
    worker_threads.each { |t| t.join }

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
