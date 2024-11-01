# frozen_string_literal: true

module Races
  # Transaction to create a new ledger
  class CreateTransaction
    include Dry::Transaction(container: AtrOne::Container)

    check :check_params
    map :build_race_model
    try :generate_source_updates, catch: ActiveRecord::ActiveRecordError
    try :perform_race, catch: ActiveRecord::ActiveRecordError
    try :record_race_result, catch: ActiveRecord::ActiveRecordError

    def check_params(params)
      true # no-op for now
    end

    def build_race_model(params)
      Race.new(params)
    end

    def generate_source_updates(race)
      updates = race.update_count
                    .times
                    .map do |index| 
                      CounterUpdate.create!(
                        counter_code: race.counter_code,
                        month_code: race.month_code,
                        value: index + 1
                      )
                    end 
      { race: race, updates: updates }
    end

    def perform_race(race:, updates:, processor: DatabaseLockingProcessor.new, driver: MultithreadedDriver.new)
      started_at = Time.now
      driver.call(
        updates: updates,
        processor: processor,
        thread_count: race.thread_count,
        race_delay: race.race_delay,
        lock_timeout: race.lock_timeout
      )
      duration = Time.now - started_at

      month = Month.find_by(code: race.month_code)
      race.race_results.build(
        started_at: started_at,
        duration: duration,
        counter_count: Counter.where(month: month, code: race.counter_code).count
      )
    end

    def record_race_result(race_result)
      race_result.tap { |record| record.save! }
    end
  end
end
