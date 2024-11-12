# Be sure to name this file after the component. Otherwise you see
# Bootable component :xxx was already registered (Dry::System::DuplicatedComponentKeyError) errors.

AtrOne::Container.boot(:logging_setup) do |container|
  # Basic setup code, eg require third party code and perform basic configuration
  init do
  end

  # Code that needs to run for a component to be usable at application's runtime.
  start do
    container[:logger].level = ENV.fetch('LOG_LEVEL', 0)
  end

  # Code that needs to run to stop a component, eg close a database connection, clear some artifacts etc
  stop do
  end
end
