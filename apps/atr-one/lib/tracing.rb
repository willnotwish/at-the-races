module Tracing
  def trace(msg)
    return unless logger

    logger.tagged Process.pid do
      logger.tagged Thread.current.object_id do
        logger.tagged self.class.name.underscore.dasherize do
          logger.debug(msg)
        end
      end
    end
  end
end
