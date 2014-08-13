class CybersourceProfile
  include ActiveModel::Validations

  attr_reader :profile_id, :name, :service, :access_key, :secret_key, :return_url, :transaction_type
  validates_presence_of :profile_id, :name, :service, :access_key, :secret_key, :return_url,
                        :transaction_type
  validates_inclusion_of :service, :in => ['test', 'live'], allow_nil: false

  def initialize(profile_id)
    @profile_id = profile_id
    # this is verbose, but I don't want to blindly use instance_variable_set
    @name = CYBERSOURCE_PROFILES[profile_id]['name']
    @service = CYBERSOURCE_PROFILES[profile_id]['service']
    @access_key = CYBERSOURCE_PROFILES[profile_id]['access_key']
    @secret_key = CYBERSOURCE_PROFILES[profile_id]['secret_key']
    @return_url = CYBERSOURCE_PROFILES[profile_id]['return_url']
    @transaction_type = CYBERSOURCE_PROFILES[profile_id]['transaction_type']

    # TODO: get this working - how to load Rails array class, for to_sentence?
    unless self.valid?
      puts self.errors.messages.to_sentence
    end
  end

  def transaction_url
    if @service == 'live'
      'https://secureacceptance.cybersource.com/silent/pay'
    else
      'https://testsecureacceptance.cybersource.com/silent/pay'
    end
  end
end
