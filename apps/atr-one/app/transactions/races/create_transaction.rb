# frozen_string_literal: true

module Races
  # Transaction to create a new ledger
  class CreateTransaction
    include Dry::Transaction(container: AtrOne::Container)

    check :check_params
    map :build_race_model
    try :generate_source_updates, catch: ActiveRecord::ActiveRecordError
    map :resolve_processor
    map :resolve_driver
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

    DEFAULT_PROCESSOR = DatabaseLockingProcessor.new

    def resolve_processor(race:, **opts)
      processor =
        if race.driver.present?
          AtrOne::Container.resolve(race.processor)
        else
          DEFAULT_PROCESSOR
        end

      { race: race, processor: processor, **opts }
    end

    DEFAULT_DRIVER = MultiprocessDriver.new

    def resolve_driver(race:, **opts)
      driver = 
        if race.driver.present?
          AtrOne::Container.resolve(race.driver)
        else
          DEFAULT_DRIVER
        end

      { race: race, driver: driver, **opts }
    end

    def perform_race(race:, processor:, driver:, updates:)
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

    def record_race_result(race:, update_groups:, started_at:, duration:)
      race.save!

      month = Month.find_by(code: race.month_code)
      result = race.race_results.create!(
        started_at: started_at,
        duration: duration,
        counter_count: Counter.where(month: month, code: race.counter_code).count
      )

      # Update groups are keyed by thread or process ID, depending on how the updates were processed
      update_groups.each do |key, updates|
        updates.each { |update| update.update!(race_result: result, processed_by: key) }
      end

      result
    end
  end
end
