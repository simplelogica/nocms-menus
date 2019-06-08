module NoCms::Menus
  class MenuItem < ActiveRecord::Base
    include NoCms::Menus::Concerns::TranslationScopes
    extend Enumerize

    enumerize :rel, in: ['', :alternate, :author, :bookmark, :help, :license, :next,
                         :nofollow, :noreferrer, :prefetch, :prev, :search, :tag]

    translates :name, :external_url, :draft, :leaf_with_draft
    accepts_nested_attributes_for :translations

    delegate :leaf_with_draft?, to: :translation

    acts_as_nested_set scope: :menu

    belongs_to :menu, inverse_of: :menu_items, class_name: "::NoCms::Menus::Menu", touch: true
    belongs_to :menuable, polymorphic: true

    accepts_nested_attributes_for :children, allow_destroy: true

    validates :name, :kind, :menu, presence: true

    before_validation :copy_parent_menu
    before_save :set_menuable_type
    after_save :set_leaf_with_draft
    after_save :set_default_position
    after_save :set_draft_by_kind

    scope :leaves_with_draft, ->() { where_with_locale leaf_with_draft: true }

    scope :active_for, ->(options = {}) do
      # Now we search the active menu item. First we search for the any active for the current object, then the action and then an static url
      # If there's no param (object, action or url) or an active item for the param then we search the next one
      return active_for_object(options[:object]) unless options[:object].nil? || !active_for_object(options[:object]).exists?
      return active_for_action(options[:action]) unless options[:action].nil? || !active_for_action(options[:action]).exists?
      return active_for_external_url(options[:url]) unless options[:url].nil?
      return none

    end

    # In this scope we should be able to accept a collection of objects, since
    # some actions may trigger many menu items directly (e.g A product menu item
    # may want to activate menu items for its product categories that are in
    # different menus)
    scope :active_for_object, ->(object_or_objects) do
      # if our object is an Array or an AR Collection we get the
      if object_or_objects.is_a?(Array) || object_or_objects.is_a?(ActiveRecord::Relation)
        menuable_type_column = arel_table[:menuable_type]
        menuable_id_column = arel_table[:menuable_id]

        # We group the objects by class
        object_groups = object_or_objects.group_by(&:class)

        object_condition = object_groups.inject(nil) { |previous_condition, object_group|
          object_group_class, object_group_instances = object_group

          # And the for each class we check the menuable_type and menuable_id columns
          condition = menuable_type_column.eq(object_group_class.name).and(
            menuable_id_column.in(object_group_instances.map(&:id))
          )

          # If there was not a previous condition then this is the right one.
          # If there was one we make an OR.
          if previous_condition.nil?
            condition
          else
            previous_condition.or(condition)
          end
        }

        where object_condition
      else
        #if it's a simple object, then a simple query
        where menuable_type: object_or_objects.class.to_s, menuable_id: object_or_objects.id
      end

    end

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

    ##
    # In this method we check that the menuable is equal or is contained in the
    # object_or_objects parameter.
    def active_for_object? object_or_objects
      # If the object is nil then we don't check anything
      !object_or_objects.nil?  && (
        (menuable == object_or_objects) || # the param is equal to the menuable OR
        ( # The param is a collection that includes the menuable
          (object_or_objects.is_a?(Array) || object_or_objects.is_a?(ActiveRecord::Relation)) &&
          object_or_objects.include?(menuable))
      )
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
          controller, action = menu_kind[:action].split('#')
          # When we are inside an engine we need to prepend '/' to the controller, or else it would search the controller in the current engine
          locale = NoCms::Menus.localize_urls ? {locale: I18n.locale.to_s} : {}
          { controller: "/#{controller}", action: action }.merge locale
        else
          external_url || '#' # Anchor string for url_for if there isn't any other destination
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

    def set_leaf_with_draft
      translations.each do |translation|
        I18n.with_locale(translation.locale) do
          previous_leaf_flag = translation.leaf_with_draft
          translation.update_column :leaf_with_draft, !draft && (leaf? || !descendants.no_drafts.exists?)
          self.parent.set_leaf_with_draft unless root? || (previous_leaf_flag == self.leaf_with_draft)
        end
      end
    end

    def draft
      # Avoid crash when no menu kind is set
      if menu_kind.blank?
        translation.draft
      else
        menu_kind[:hidden] ? true : translation.draft
      end
    end

    def draft?
      draft
    end

    private

    def set_default_position
      self.update_attribute :position, ((menu.menu_items.pluck(:position).compact.max || 0) + 1) if self[:position].blank?
    end

    def set_draft_by_kind
      translations.each do |t|
        t.update_attribute :draft, true if !t.draft && menu_kind[:hidden]
      end
    end

    private def set_menuable_type
      self.menuable_type = menu_kind[:object_class].to_s
    end

  end
end
