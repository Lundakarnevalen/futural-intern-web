source 'https://rubygems.org'

# Main rails dependency
gem 'rails', '4.0.2'

# Security is overrated.
gem 'protected_attributes'

# Production dependencies
group :production do
  gem 'mysql2'
end

# Development dependencies
group :development do
  gem 'sqlite3'
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
end
