# Current Ruby version
ruby_version = Gem::Version.new(RUBY_VERSION)

# Globalize latest version (5.3.0) demands ruby over 2.4.6. We need to force
# another version in prior versions
ruby_2_4_6 = Gem::Version.new('2.4.6')

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

appraise "rails-5-0-mysql" do
  gem "mysql2"
  gem "rails", "5.0.1"
  gem "globalize", git: 'git@github.com:globalize/globalize.git', branch: 'master'
  gem 'activeresource', github: 'rails/activeresource'
  gem "activesupport", "~> 5.0.0"
  gem "awesome_nested_set", '~> 3.1.1'
end

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

appraise "rails-5-0-pgsql" do
  gem "pg"
  gem "rails", "5.0.1"
  gem 'activeresource', github: 'rails/activeresource'
  gem "activesupport", "~> 5.0.0"
  gem "awesome_nested_set", '~> 3.1.1'
  if ruby_version < ruby_2_4_6
    gem 'globalize', '~> 5.2.0'
  else
    gem "globalize", git: 'git@github.com:globalize/globalize.git', branch: 'master'
  end
end

appraise "rails-5-2-3-pgsql" do
  gem "pg"
  gem "rails", "5.2.3"
  gem 'activeresource', github: 'rails/activeresource'
  gem "activesupport", "~> 5.2.3"
  gem "awesome_nested_set", '~> 3.1.1'

  if ruby_version < ruby_2_4_6
    gem 'globalize', '~> 5.2.0'
  else
    gem "globalize", git: 'git@github.com:globalize/globalize.git', branch: 'master'
  end
end