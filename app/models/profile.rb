class Profile < ActiveRecord::Base
  validates_presence_of :name, :service, :profile_id, :access_key, :secret_key
end
