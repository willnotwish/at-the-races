module Notifiable
  extend ActiveSupport::Concern

  def publish_event(event_type, json)
    return unless message_bus

    message_bus.publish(self.class.event_type, json)
  end

  class << self
    def event_type
      @event_type ||= name.underscore.dasherize
    end
  end
end
