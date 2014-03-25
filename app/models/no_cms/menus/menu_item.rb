module NoCms::Menus
  class MenuItem < ActiveRecord::Base

    translates :name

    acts_as_nested_set

    belongs_to :menu

    validates :name, presence: true

  end
end
