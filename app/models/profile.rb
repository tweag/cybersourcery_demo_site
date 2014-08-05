class Profile < ActiveRecord::Base
  validates_presence_of :name, :service, :profile_id, :access_key, :secret_key, :return_url,
                        :transaction_type
  validates_inclusion_of :service, :in => ['test', 'live'], allow_nil: false

  def transaction_url
    if self.service == 'live'
      'https://secureacceptance.cybersource.com/silent/pay'
    else
      'https://testsecureacceptance.cybersource.com/silent/pay'
    end
  end
end
