module NoCms::Menus
  class MenuItem < ActiveRecord::Base

    translates :name, :external_url

    acts_as_nested_set

    belongs_to :menu
    belongs_to :menuable, polymorphic: true

    validates :name, presence: true

  end
end
