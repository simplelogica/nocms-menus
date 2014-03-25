module NoCms::Menus
  class MenuItem < ActiveRecord::Base
    belongs_to :menu
  end
end
