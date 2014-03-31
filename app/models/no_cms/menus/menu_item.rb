module NoCms::Menus
  class MenuItem < ActiveRecord::Base

    translates :name, :external_url, :draft

    acts_as_nested_set

    belongs_to :menu
    belongs_to :menuable, polymorphic: true

    accepts_nested_attributes_for :children, allow_destroy: true

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


    scope :drafts, ->() { where_with_locale(draft: true) }
    scope :no_drafts, ->() { where_with_locale(draft: false) }

    after_save :set_default_position

    def active_for?(options = {})

      return active_for_object?(options[:object]) unless options[:object].nil?
      return active_for_action?(options[:action]) unless options[:action].nil?
      return active_for_external_url?(options[:url]) unless options[:url].nil?

      false

    end

    def active_for_object? object
      !object.nil?  && (menuable == object)
    end

    def active_for_action? action
      !action.nil?  && (menu_action == action)
    end

    def active_for_external_url? external_url
      !external_url.nil?  && (self.external_url == external_url)
    end

    def url_for
      case
        when !menuable.nil?
          menuable.respond_to?(:path) ? menuable.path : menuable
        when !menu_action.blank?
          controller, action = menu_action.split('#')
          { controller: controller, action: action }
        when !external_url.blank?
          external_url
      end
    end

    def position
      self[:position] || 0
    end

    private

    def set_default_position
      self.update_attribute :position, ((menu.menu_items.pluck(:position).compact.max || 0) + 1) if self[:position].blank?
    end


  end
end
