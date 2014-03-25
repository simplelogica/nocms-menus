class Page < ActiveRecord::Base
  has_many :menu_items, class_name: 'NoCms::Menus::MenuItem', as: :menuable
end
