require 'rack/translating_proxy'

class CybersourceryTranslatingProxy < Rack::TranslatingProxy

  def target_host
    'http://localhost:5556'
  end

  def request_mapping
    {
      'http://localhost:5555' => target_host,
      # map the response address registered with Cybersource to the local server
      'http://cybersourcery.dev/confirm' => 'http://tranquil-ocean-5865.herokuapp.com/confirm'
    }
  end
end
