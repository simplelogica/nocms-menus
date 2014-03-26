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
      return active_for_action(action) unless options[:action].nil?
      external_url = options[:url]
      return active_for_external_url(external_url) unless options[:url].nil?
    end

    scope :active_for_object, ->(object) { where menuable_type: object.class, menuable_id: object.id }

    scope :active_for_action, ->(action) { where menu_action: action }

    scope :active_for_external_url, ->(external_url) { where external_url: external_url }

  end
end
