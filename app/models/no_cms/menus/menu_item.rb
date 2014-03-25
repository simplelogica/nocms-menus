module NoCms::Menus
  class MenuItem < ActiveRecord::Base

    translates :name

    belongs_to :menu

    validates :name, presence: true

  end
end
