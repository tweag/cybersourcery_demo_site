json.array!(@profiles) do |profile|
  json.extract! profile, :id, :name, :service, :profile_id, :access_key, :secret_key
  json.url profile_url(profile, format: :json)
end
