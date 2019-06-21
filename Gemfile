source "https://rubygems.org"

# Declare your gem's dependencies in menus.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

group :development, :test do
  gem 'faker'
  gem 'test_engine', path: 'spec/dummy/vendor/test_engine'
  gem 'pry'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'capybara'
  gem 'appraisal'
end
