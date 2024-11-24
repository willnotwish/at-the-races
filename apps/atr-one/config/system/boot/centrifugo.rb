# Be sure to name this file after the component

AtrOne::Container.boot(:centrifugo) do |container|
  init do
    secrets = JSON.parse(File.read('/run/secrets/centrifugo.json'))

    register(
      :centrifugo_client,
      Cent::Client.new(api_key: secrets['api_key'], endpoint: secrets['endpoint'])
    )

    register(
      :centrifugo_notary,
      Cent::Notary.new(secret: secrets['token_hmac_secret_key'])
    )
  end
end
