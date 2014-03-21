source 'https://rubygems.org'

# Main rails dependency
gem 'rails', '4.0.2'

# General dependencies
gem 'devise'
gem 'gcm'
gem 'postmark-rails'
gem 'carrierwave'
gem 'fog'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-modal-rails'
gem 'jquery-cookie-rails'
gem 'browser'
gem 'cancan'
gem 'podio'
gem 'axlsx_rails'
gem 'pry-rails'
gem 'pry-doc'
gem 'bootstrap-sass'

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end

group :production, :development do
  gem 'mysql2'
end

group :development do
  gem 'thin'
end

group :test do
  gem 'rspec-rails'
end

group :development, :test do
  gem 'sqlite3'
  gem 'factory_girl_rails', '4.2.0'
  gem 'database_cleaner','1.0.1'
  gem 'json_spec', '1.1.1'
end

group :assets do
  gem 'uglifier'
  gem 'sass-rails'
end
