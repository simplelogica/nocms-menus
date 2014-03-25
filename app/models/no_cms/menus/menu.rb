module NoCms::Menus
  class Menu < ActiveRecord::Base
    translates :name

    validates :name, :uid, presence: true
    validates :uid, uniqueness: true
  end
end
