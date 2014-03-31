module NoCms::Menus
  class Menu < ActiveRecord::Base
    translates :name

    has_many :menu_items
    accepts_nested_attributes_for :menu_items, allow_destroy: true

    validates :name, :uid, presence: true
    validates :uid, uniqueness: true
  end
end
