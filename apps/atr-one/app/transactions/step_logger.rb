# frozen_string_literal: true

# Logs step progress
class StepLogger
  attr_reader :prefix, :logger

  def initialize(logger: Rails.logger, prefix: nil)
    @logger = logger
    @prefix = prefix
  end

  def on_step(event)
    trace(event: event, status: :starting)
  end

  def on_step_succeeded(event)
    trace(event: event, status: :success)
  end

  def on_step_failed(event)
    trace(event: event, status: :failure, level: :warn)
  end

  private

  def trace(event:, **opts)
    return unless logger

    logger.tagged(prefix&.to_s&.dasherize) do
      logger.tagged(event.payload[:step_name]) do
        log_event(event: event, **opts)
      end
    end
  end

  def log_event(event:, status: nil, level: :info)
    status ||= event.id
    payload = event.payload
    logger.send(level, "#{status}; args: #{payload[:args]}")
  end
end
