module NoCms::Menus
  class Menu < ActiveRecord::Base
    translates :name

    has_many :menu_items

    validates :name, :uid, presence: true
    validates :uid, uniqueness: true
  end
end
