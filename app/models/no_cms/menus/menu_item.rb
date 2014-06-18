module NoCms::Menus
  class MenuItem < ActiveRecord::Base
    include Concerns::TranslationScopes

    translates :name, :external_url, :draft

    acts_as_nested_set

    belongs_to :menu, inverse_of: :menu_items
    belongs_to :menuable, polymorphic: true

    accepts_nested_attributes_for :children, allow_destroy: true

    validates :name, :kind, :menu, presence: true

    before_validation :copy_parent_menu
    after_save :set_default_position

    scope :active_for, ->(options = {}) do
      # Now we search the active menu item. First we search for the any active for the current object, then the action and then an static url
      # If there's no param (object, action or url) or an active item for the param then we search the next one
      return active_for_object(options[:object]) unless options[:object].nil? || !active_for_object(options[:object]).exists?
      return active_for_action(options[:action]) unless options[:action].nil? || !active_for_action(options[:action]).exists?
      return active_for_external_url(options[:url]) unless options[:url].nil?
      return none

    end

    scope :active_for_object, ->(object) { where menuable_type: object.class, menuable_id: object.id }

    scope :active_for_action, ->(action) { where menu_action: action }

    scope :active_for_external_url, ->(external_url) { where external_url: external_url }


    scope :drafts, ->() { where_with_locale(draft: true) }
    scope :no_drafts, ->() { where_with_locale(draft: false) }


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
        when !menu_kind[:object_class].nil?
          menuable.respond_to?(:path) ? menuable.path : menuable
        when !menu_kind[:action].nil?
          controller, action = menu_action.split('#')
          # When we are inside an engine we need to prepend '/' to the controller, or else it would search the controller in the current engine
          { controller: "/#{controller}", action: action }
        else
          external_url
      end
    end

    def route_set
      menu_kind[:route_set]
    end

    def position
      self[:position] || 0
    end

    def menu_kind
      NoCms::Menus.menu_kinds[self.kind]
    end

    def copy_parent_menu
      self.menu = parent.menu unless parent.nil?
    end

    private

    def set_default_position
      self.update_attribute :position, ((menu.menu_items.pluck(:position).compact.max || 0) + 1) if self[:position].blank?
    end


  end
end
