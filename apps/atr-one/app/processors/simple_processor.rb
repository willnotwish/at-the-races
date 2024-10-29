class SimpleProcessor
  include Tracing
  
  def call(update:, **)
    trace 'Starting...'
    raise ArgumentError, 'update parameter must be specified' unless update
    
    month = Month.find_by!(code: update.month_code)
    trace "Month: #{month.code}"

    counter = Counter.find_or_create_by!(code: update.counter_code, month: month)

    trace "Updating counter #{counter.code} with value: #{update.value}"
    counter.update!(value: update.value)
    trace 'Done'
  end
end
