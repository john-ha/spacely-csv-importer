source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2", ">= 7.2.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4", ">= 6.4.3"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Decorate the models for use in the views [https://github.com/drapergem/draper]
gem "draper", "~> 4.0", ">= 4.0.2"

# DB-based queueing backend for Active Job [https://github.com/rails/solid_queue]
gem "solid_queue", "~> 0.9.0"

# Bulk update or insert records in the database [https://github.com/zdennis/activerecord-import]
gem "activerecord-import", "~> 1.8"

# Use Amazon S3 for Active Storage [https://github.com/aws/aws-sdk-ruby]
gem "aws-sdk-s3", "~> 1.166"

# For pagination [https://github.com/kaminari/kaminari]
gem "kaminari", "~> 1.2", ">= 1.2.2"

# For API documentation & testing [https://github.com/rswag/rswag/]
gem "rswag", "~> 2.14", ">= 2.14.0"

# For using Stripe-style prefixed IDs for models [https://github.com/excid3/prefixed_ids]
gem "prefixed_ids", "~> 1.7"

# For validating parameters in Rails controllers [https://github.com/nicolasblanco/rails_param]
gem "rails_param", "~> 1.3", ">= 1.3.1"

# For allowing search functionality on models [https://github.com/activerecord-hackery/ransack]
gem "ransack", "~> 4.2", ">= 4.2.1"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # Generate fake data for seeding and testing [https://github.com/faker-ruby/faker]
  gem "faker", "~> 3.4", ">= 3.4.2"

  # RSpec testing framework [https://github.com/rspec/rspec-rails]
  gem "rspec-rails", "~> 7.0.0"

  # Fixture replacement for focused and readable tests [https://github.com/thoughtbot/factory_bot]
  gem "factory_bot_rails", "~> 6.4", ">= 6.4.3"

  # Load environment variables from .env into ENV in development [https://github.com/bkeepers/dotenv]
  gem "dotenv", "~> 3.1", ">= 3.1.4"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Annotate Ruby files with useful comments [https://github.com/ctran/annotate_models]
  gem "annotate", "~> 3.2"

  # Unconfigurable linter and formatter for Ruby code [https://github.com/standardrb/standard]
  gem "standard", "~> 1.40"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  # Provides one-liners to test common Rails functionality [https://github.com/thoughtbot/shoulda-matchers]
  gem "shoulda-matchers", "~> 6.4"

  # Provides code coverage for Ruby [https://github.com/simplecov-ruby/simplecov]
  gem "simplecov", "~> 0.22.0"
end
