module NoCms::Menus
  class MenuItem < ActiveRecord::Base

    translates :name, :external_url

    acts_as_nested_set

    belongs_to :menu
    belongs_to :menuable, polymorphic: true

    validates :name, presence: true

    scope :active_for, ->(options) do
      object = options[:object]
      return active_for_object(object) unless options[:object].nil?
      action = options[:action]
      active_for_action(action) unless options[:action].nil?
    end

    scope :active_for_object, ->(object) { where menuable_type: object.class, menuable_id: object.id }

    scope :active_for_action, ->(action) { where menu_action: action }

  end
end
