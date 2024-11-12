class RunRaceJob < ActiveJob::Base
  queue_as :default

  def perform(race_params)
    Races::CreateTransaction
      .new
      .tap { |creation| creation.subscribe(StepLogger.new) }
      .call(race_params) do |match|
        match.success { |race_result| Rails.logger.info "Race over. Result: #{race_result.inspect}" }

        # match.failure(:check_params) { |errors| raise ActionController::BadRequest, errors.to_s }
        match.failure { |error| raise error }
      end
  end
end
