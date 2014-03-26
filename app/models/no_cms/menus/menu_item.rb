module NoCms::Menus
  class MenuItem < ActiveRecord::Base

    translates :name, :external_url

    acts_as_nested_set

    belongs_to :menu
    belongs_to :menuable, polymorphic: true

    validates :name, presence: true

    scope :active_for, ->(options = {}) do

      return active_for_object(options[:object]) unless options[:object].nil?
      return active_for_action(options[:action]) unless options[:action].nil?
      return active_for_external_url(options[:url]) unless options[:url].nil?
      return none

    end

    scope :active_for_object, ->(object) { where menuable_type: object.class, menuable_id: object.id }

    scope :active_for_action, ->(action) { where menu_action: action }

    scope :active_for_external_url, ->(external_url) { where external_url: external_url }

  end
end
