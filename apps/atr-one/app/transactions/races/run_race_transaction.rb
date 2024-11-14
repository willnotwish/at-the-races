# frozen_string_literal: true

module Races
  # Transaction to run the given race
  class RunRaceTransaction
    include Dry::Transaction(container: AtrOne::Container)

    map :find_race
    try :generate_source_updates, catch: ActiveRecord::ActiveRecordError
    map :resolve_processor
    map :resolve_driver
    try :call_driver, catch: ActiveRecord::ActiveRecordError
    try :record_result, catch: ActiveRecord::ActiveRecordError

    def find_race(id)
      Race.find(id)
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

    def resolve_processor(race:, **opts)
      processor = AtrOne::Container.resolve(race.processor)

      { race: race, processor: processor, **opts }
    end

    def resolve_driver(race:, **opts)
      driver = AtrOne::Container.resolve(race.driver)

      { race: race, driver: driver, **opts }
    end

    def call_driver(race:, processor:, driver:, updates:)
      started_at = Time.now
      update_groups = driver.call(
        updates: updates,
        processor: processor,
        thread_count: race.thread_count,
        race_delay: race.race_delay,
        lock_timeout: race.lock_timeout
      )

      { race: race, update_groups: update_groups, started_at: started_at, duration: Time.now - started_at }
    end

    def record_result(race:, update_groups:, started_at:, duration:)
      month = Month.find_by(code: race.month_code)
      result = race.race_results.create!(
        started_at: started_at,
        duration: duration,
        counter_count: Counter.where(month: month, code: race.counter_code).count
      )

      # Update groups are keyed by thread or process ID, depending on how the updates were processed
      update_groups.each do |thread_or_process_id, updates|
        updates.each { |update| update.update!(race_result: result, processed_by: thread_or_process_id) }
      end

      result
    end
  end
end
