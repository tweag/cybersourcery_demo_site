require 'active_support'
require 'active_support/core_ext/array/conversions.rb' # so we can use to_sentence

class Profile
  include ActiveModel::Validations

  VALID_ENDPOINTS = {
    standard: '/silent/pay',
    create_payment_token: '/silent/token/create',
    update_payment_token: '/silent/token/update',
    iframe_standard: '/silent/embedded/pay',
    iframe_create_payment_token: 'silent/embedded/token/create',
    iframe_update_payment_token: '/silent/embedded/token/update'
  }

  attr_reader :profile_id, :name, :service, :access_key, :secret_key, :success_url,
              :transaction_type, :endpoint_type, :conversions
  validates_presence_of :profile_id, :name, :service, :access_key, :secret_key, :success_url
  validates_inclusion_of :service, :in => %w(test live), allow_nil: false
  validates_inclusion_of :endpoint_type, :in => VALID_ENDPOINTS.stringify_keys.keys, allow_nil: false

  def initialize(profile_id, profiles = CYBERSOURCE_PROFILES)
    @profile_id = profile_id
    # this is verbose, but I don't want to blindly use a loop with instance_variable_set calls
    @name = profiles[profile_id]['name']
    @service = profiles[profile_id]['service']
    @access_key = profiles[profile_id]['access_key']
    @secret_key = profiles[profile_id]['secret_key']
    @success_url = profiles[profile_id]['success_url']
    @transaction_type = profiles[profile_id]['transaction_type']
    @endpoint_type = profiles[profile_id]['endpoint_type']

    unless self.valid?
      raise Exceptions::CybersourceryError, self.errors.full_messages.to_sentence
    end
  end

  def transaction_url(env = Rails.env)
    if env == 'test'
      "#{SORCERY_URL}/silent/pay"
    elsif @service == 'live'
      'https://secureacceptance.cybersource.com/silent/pay'
    elsif @service == 'test'
      'https://testsecureacceptance.cybersource.com/silent/pay'
    else
      raise Exceptions::CybersourceryError, 'Invalid conditions for determining the transaction_url'
    end
  end
end
