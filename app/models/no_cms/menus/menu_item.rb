module NoCms::Menus
  class MenuItem < ActiveRecord::Base

    translates :name, :external_url

    acts_as_nested_set

    belongs_to :menu
    belongs_to :menuable, polymorphic: true

    validates :name, presence: true

    scope :active_for, ->(options) do
      object = options[:object]
      active_for_object(object) unless options[:object].nil?
    end

    scope :active_for_object, ->(object) { where menuable_type: object.class, menuable_id: object.id }

  end
end
