module NoCms
  module Menus
    module Concerns
      module TranslationScopes
        extend ActiveSupport::Concern
        included do
          scope :where_with_locale, ->(where_params, locale = ::I18n.locale) {
            with_translations(locale).where(translation_class.table_name => where_params)
          }
        end
      end
    end
  end
end
