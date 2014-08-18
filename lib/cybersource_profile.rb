require 'active_support'
require 'active_support/core_ext/array/conversions.rb' # so we can use to_sentence

class CybersourceProfile
  include ActiveModel::Validations

  attr_reader :profile_id, :name, :service, :access_key, :secret_key, :success_url, :transaction_type, :conversions
  validates_presence_of :profile_id, :name, :service, :access_key, :secret_key, :success_url,
                        :transaction_type
  validates_inclusion_of :service, :in => ['test', 'live'], allow_nil: false

  def initialize(profile_id, cybersource_profiles = CYBERSOURCE_PROFILES)
    @profile_id = profile_id
    # this is verbose, but I don't want to blindly use a loop with instance_variable_set calls
    @name = cybersource_profiles[profile_id]['name']
    @service = cybersource_profiles[profile_id]['service']
    @access_key = cybersource_profiles[profile_id]['access_key']
    @secret_key = cybersource_profiles[profile_id]['secret_key']
    @success_url = cybersource_profiles[profile_id]['success_url']
    @transaction_type = cybersource_profiles[profile_id]['transaction_type']

    unless self.valid?
      raise CybersourceryError, self.errors.full_messages.to_sentence
    end
  end

  def transaction_url
    if Rails.env.test?
      # Point to Sorcery, which has canned responses from the actual test service
      # TODO: don't hardcode the Sorcery URL like this
      'http://localhost:2134/silent/pay'
    elsif @service == 'live'
      'https://secureacceptance.cybersource.com/silent/pay'
    elsif @service == 'test'
      'https://testsecureacceptance.cybersource.com/silent/pay'
    else
      raise CybersourceryError, 'Invalid value for @service'
    end
  end
end
