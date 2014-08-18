rails_root = Rails.root || File.dirname(__FILE__) + '/../..'
CYBERSOURCE_PROFILES = YAML.load_file("#{rails_root}/config/cybersource_profiles.yml")
SORCERY_URL = 'http://localhost:4567'
