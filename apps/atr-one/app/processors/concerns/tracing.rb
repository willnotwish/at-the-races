module Tracing
  extend ActiveSupport::Concern

  def trace(msg)
    return unless logger

    logger.tagged Thread.current.object_id do
      logger.tagged self.class.class_tag do
        logger.debug(msg)
      end
    end
  end

  class_methods do
    def class_tag
      @class_tag ||= name.underscore.dasherize
    end
  end
end
