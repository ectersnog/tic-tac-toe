# frozen_string_literal: true

source "https://rubygems.org"

gem "dry-initializer"
gem "dry-initializer-rails"
gem "dry-operation"
gem "dry-schema"
gem "jbuilder"
gem "ostruct"
gem "pry"
gem "puma", ">= 5.0"
gem "rails", "~> 8.0.2"
gem "redis"
gem "rswag-api", "~> 2.16"
gem "rswag-ui", "~> 2.16"
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails"
  gem "rswag-specs"
  gem "rubocop-factory_bot", "~> 2.27"
  gem "rubocop-rails", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rspec_rails", require: false
end

group :test do
  gem "shoulda-matchers"
end
