# NoCMS Pages

## What's this?

This is a Rails engine with a basic functionality of flexible configurable menus stored in a database, so user can create, delete or modify menus via an admin interface (or at least through the databse). It's not attached to any particular CMS so you can use it freely within your Rails application without too much dependencies.

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

## How does it works?

NoCms Menus allow to create some "menu item" categories that can be attached to an object, an action/controller or an static url.

### Menu Kinds

This configuration is made through the `config/initializers/no_cms/menus.rb` file.

```ruby
NoCms::Menus.configure do |config|

  config.menu_kinds = {
    'page' => {
      object_class: Page,
    },
    'product' => {
      object_class: Product,
      object_name_method: :name
    },
    'products' => {
      action: 'products#index'
    },
    'fixed_url' => {
      external_url:  true
    }
  }

end

```

In the example there are four kinds of menu items: page, product, products and fixed_url. We will explain now each kind of menu item:

#### Object Classes: Page and Product

The first option for a menu_kind is to attach it to an ActiveRecord class. The `NoCms::Menus::MenuItem` class has a polymorphic relationship that will be used for each instance to retrieve the object attached.

The URL corresponding with that menu item will be the result of executing [polymorphic_path](http://api.rubyonrails.org/classes/ActionDispatch/Routing/PolymorphicRoutes.html#method-i-polymorphic_path) using the associated object.

```ruby
menu_item = NoCms::Menu::Item.create kind: :page, menuable: Page.first

show_submenu menu_item # => It will show (among other things) -> link_to(menu_item.name, main_app.polymorphic_path(Page.first))
```

There's one exception to this `polymorphic_path` solution. If the model defines a path method (maybe because it has a mechanism to customize paths) then this path method will be used.

```ruby
menu_item = NoCms::Menu::Item.create kind: :page, menuable: Page.first

Page.first.path # => an-awesome/customized/path-for-seo

show_submenu menu_item # => It will show (among other things) -> link_to(menu_item.name, Page.first.path)
```

The other option of the menu kind (`object_name_method`) is thought to be used by the admin interface (read about admin interface at the end of this README) and will allow to list all the instances from the attached ActiveRecord model.

#### Action: Products

Sometimes we need to attach a menu item not to an object, but to a controller and an action. The syntax used for the configuration is the standard one used by Rails in other places `namespace/controller#action`.

Following the previous configuration:

```ruby
menu_item = NoCms::Menu::Item.create kind: :products

show_submenu menu_item # => It will show (among other things) -> link_to(menu_item.name, main_app.url_for('products#index'))
```

#### External url

Other times we would like to link to a fixed url (normally an external one we can't automatically build from the Rails routes system). The external_url setting allows us to do it.

The external_url attribute from the model will be used to print the url.

```ruby
menu_item = NoCms::Menu::Item.create kind: :fixed_url

show_submenu menu_item # => It will show (among other things) -> link_to(menu_item.name, menu_item.external_url)
```

### Route sets

One of the most interesting of Rails features is the ability to modularize our apps using engines. This modularization allow us to have separate functionalities properly isolated in our application making code sharing and reusing quite easier (in fact, this nocms-menus gem is an engine!).

One concept coming from this isolation of routes is that of [Route Sets](http://guides.rubyonrails.org/engines.html#routes) that creates contexts of routes were helpers are defined (you can see an example in the previous link).

This mean that since our menu is normally displayed in all of our app we have to know in which RouteSet the `polymorphic_path` or `url_for` is being called.

If we are using routes from an engine (i.e. we are using routes from our news engine, which is mounted in the routes as :news) we need to configure the right route_set to be called:

```ruby
NoCms::Menus.configure do |config|

  config.menu_kinds = {
    'news' => {
      object_class: NewsEngine::NewsItem,
      route_set: :news
    }
  }

end
```

This way, the route set will be used:

```ruby
menu_item = NoCms::Menu::Item.create kind: :news, menuable: NewsEngine::NewsItem.first

show_submenu menu_item # => It will show (among other things) -> link_to(menu_item.name, news.polymorphic_path(NewsEngine::NewsItem.first))
```

If you look carefully you'll see that no main_app has been used to call the polymorphic path. Instead, the news route_set has been used.

`main_app` is only used when no route_set has been configured in the menu kind.
