# Current Ruby version
ruby_version = Gem::Version.new(RUBY_VERSION)


# Rails 6 demands ruby over 2.4.4
ruby_2_4_4 = Gem::Version.new('2.4.4')

# Globalize latest version (5.3.0) demands ruby over 2.4.6. We need to force
# another version in prior versions
ruby_2_4_6 = Gem::Version.new('2.4.6')

if ruby_version < ruby_2_4_4

  appraise "rails-4-0-mysql" do
    gem "mysql2", "~> 0.3.13"
    gem "rails", "4.0.13"
    gem "enumerize", "1.1.1"
  end

  appraise "rails-4-1-mysql" do
    gem "mysql2", "~> 0.3.13"
    gem "rails", "4.1.14"
  end

  appraise "rails-4-2-mysql" do
    gem "mysql2"
    gem "rails", "4.2.7.1"
  end

end

appraise "rails-5-0-mysql" do
  gem "mysql2"
  gem "rails", "5.0.7.2"
  gem "awesome_nested_set", '~> 3.1.1'
end

appraise "rails-5-1-mysql" do
  gemspec
  gem "mysql2"
  gem 'rails', '5.1.7'
  gem 'rspec-rails'
  if ruby_version < ruby_2_4_6
    gem 'globalize', '~> 5.2.0'
  end
end

appraise "rails-5-2-mysql" do
  gemspec
  gem "mysql2"
  gem 'rails', '5.2.6'
  gem 'rspec-rails'
  # Rails 5.2.4 incldus a bug with previous gem versions
  # More info: https://github.com/collectiveidea/awesome_nested_set/issues/412
  gem "awesome_nested_set", '~> 3.2.0'
  if ruby_version < ruby_2_4_6
    gem 'globalize', '~> 5.2.0'
  end
end

if ruby_version > ruby_2_4_4
  appraise "rails-6-1-mysql" do
    gemspec
    gem "mysql2"
    gem 'rails', '6.1.4.1'
    gem 'rspec-rails'
  end
end

if ruby_version < ruby_2_4_4

  appraise "rails-4-0-pgsql" do
    gem "pg"
    gem "rails", "4.0.13"
    gem "enumerize", "1.1.1"
  end

  appraise "rails-4-1-pgsql" do
    gem "pg"
    gem "rails", "4.1.14"
  end

  appraise "rails-4-2-pgsql" do
    gem "pg"
    gem "rails", "4.2.7.1"
  end
end

appraise "rails-5-0-pgsql" do
  gem "pg"
  gem "rails", "5.0.7.2"
  gem "awesome_nested_set", '~> 3.1.1'
  if ruby_version < ruby_2_4_6
    gem 'globalize', '~> 5.2.0'
  end
end

appraise "rails-5-1-pgsql" do
  gemspec
  gem "pg"
  gem 'rails', '5.1.7'
  gem 'rspec-rails'
  if ruby_version < ruby_2_4_6
    gem 'globalize', '~> 5.2.0'
  end
end

appraise "rails-5-2-pgsql" do
  gem "pg"
  gem "rails", "5.2.6"
  # Rails 5.2.4 incldus a bug with previous gem versions
  # More info: https://github.com/collectiveidea/awesome_nested_set/issues/412
  gem "awesome_nested_set", '~> 3.2.0'

  if ruby_version < ruby_2_4_6
    gem 'globalize', '~> 5.2.0'
  end
end

if ruby_version > ruby_2_4_4
  appraise "rails-6-1-pgsql" do
    gemspec
    gem "pg"
    gem 'rails', '6.1.4.1'
    gem 'rspec-rails'
  end
end
