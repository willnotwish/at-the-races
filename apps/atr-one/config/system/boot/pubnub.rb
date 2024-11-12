# Be sure to name this file after the component. Otherwise you see
# Bootable component :xxx was already registered (Dry::System::DuplicatedComponentKeyError) errors.

# The YAML file /run/secrets/pubnub should look something like this:
# 
# ---
# subscribe_key: <subscribe key from pubnub keyset>
# publish_key: <publish key from pubnub keyset>
# user_id: <pubnub user id>

AtrOne::Container.boot(:pubnub) do |container|
  init do
    secrets = YAML.load_file('/run/secrets/pubnub')
    register(:pubnub, Pubnub.new(secrets.symbolize_keys))
  end
end
