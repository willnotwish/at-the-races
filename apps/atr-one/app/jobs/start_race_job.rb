class StartRaceJob < ActiveJob::Base
  queue_as :default

  def perform(params)
    Races::RunRaceTransaction
      .new
      .tap { |creation| creation.subscribe(StepLogger.new) }
      .call(params) do |match|
        match.success { |race_result| Rails.logger.info "Race over. Result: #{race_result.inspect}" }
        match.failure { |error| raise error }
      end
  end
end
