# Be sure to name this file after the component

AtrOne::Container.boot(:centrifugo) do |container|
  init do
    secrets = JSON.parse(File.read('/run/secrets/centrifugo.json'))

    client = Cent::Client.new(api_key: secrets['api_key'], endpoint: ENV['CENTRIFUGO_ENDPOINT'])
    register('centrifugo.client', client)

    notary = Cent::Notary.new(secret: secrets['token_hmac_secret_key'])
    register('centrifugo.notary', notary)
  end
end
