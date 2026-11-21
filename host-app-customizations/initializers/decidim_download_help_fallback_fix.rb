# frozen_string_literal: true

# Decidim::DownloadYourDataSerializers.help_definitions_for looks up
# "decidim.open_data.help.<entity>.<header>" first and falls back to
# "decidim.download_your_data.help.<entity>.<header>" inside a rescue. But
# production sets raise_on_missing_translations = false, so the first I18n.t
# returns the "Translation missing" string instead of raising and the fallback
# never runs. Use the bang form (I18n.t!), which always raises on a missing key,
# so the page falls back to the (already translated) download_your_data.help keys.
Rails.application.config.to_prepare do
  module Decidim
    module DownloadYourDataSerializers
      class << self
        def help_definitions_for(user)
          export_format = "CSV"
          help_definition = {}

          data_entities.each do |object|
            klass = Object.const_get(object)
            exporter = Exporters.find_exporter(export_format).new(klass.user_collection(user), klass.export_serializer)
            entity = klass.model_name.route_key
            headers = exporter.headers_without_locales
            help_definition[entity] = {}

            headers.each do |header|
              help_definition[entity][header] = begin
                I18n.t!("decidim.open_data.help.#{entity}.#{header}")
              rescue I18n::MissingTranslationData
                I18n.t("decidim.download_your_data.help.#{entity}.#{header}")
              end
            end
          end

          help_definition
        end
      end
    end
  end
end
