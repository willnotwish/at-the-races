# Processes updates in sequence on the current thread using the given processor
class SingleThreadedDriver
  include AtrOne::Deps[:logger]
  include Tracing

  def call(updates:, processor:, **)
    trace 'Starting...'
    updates.each do |update|
      trace "Processing update: #{update.inspect}"
      processor.call(update: update)
      trace '---'
    end
    trace 'Complete'
  end
end
