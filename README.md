# NoCMS Pages

## What's this?

This is a Rails engine with a basic functionality of flexible configurable menus stored in a database, so a user can create, delete or modify menus via an admin interface (or at least through the databse). It's not attached to any particular CMS so you can use it freely within your Rails application without too much dependencies.

## How do I install it?

Right now there's no proper gem, although we have a couple of projects making extensive use of it.

To install it just put the repo in your Gemfile:

```ruby
gem "nocms-menus", git: 'git@github.com:simplelogica/nocms-menus.git'
```

And then import all the migrations:

```
rake no_cms_menus:install:migrations
```

And run them

```
rake db:migrate
```

And run the initializer:

```
rails g nocms:menus
```

This will create a `config/initializers/no_cms/menus.rb` file that contains all the configuration.
