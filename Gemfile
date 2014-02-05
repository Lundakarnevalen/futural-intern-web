source 'https://rubygems.org'

# Main rails dependency
gem 'rails', '4.0.2'


# General dependencies
gem 'devise'
gem 'protected_attributes' # Security is overrated.
gem 'gcm'
gem 'postmark-rails'
gem 'carrierwave'
gem 'fog'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-modal-rails'

# Production dependencies
group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# Development dependencies
group :development do
  gem 'mysql2'
  gem 'thin'
end

# Test dependencies
group :test do
  gem 'sqlite3'
  gem 'rspec-rails'
end

# Asset compilation dependencies
group :assets do
  gem 'uglifier'
  gem 'sass-rails'
end
