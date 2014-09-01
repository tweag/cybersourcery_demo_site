require 'rack/translating_proxy'

class SilentOrderPostProxy < Rack::TranslatingProxy

  def target_host
    #'https://testsecureacceptance.cybersource.com'
    'http://localhost:5556'
  end

  def request_mapping
    {
      'http://localhost:5555' => target_host,
      'http://cybersourcery.dev/confirm' => 'http://tranquil-ocean-5865.herokuapp.com/confirm'
    }
  end
end
