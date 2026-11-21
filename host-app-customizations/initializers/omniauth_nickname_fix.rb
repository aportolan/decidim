# frozen_string_literal: true

Rails.application.config.to_prepare do
  module Decidim
    class OmniauthRegistrationForm
      # Google (and other providers) deliver an empty-string nickname, which is
      # truthy in Ruby, so the original `nickname || name` yields "" and the
      # normalized nickname becomes invalid. Fall back to the name when blank.
      def normalized_nickname
        UserBaseEntity.nicknamize(nickname.presence || name, current_organization.id)
      end
    end
  end
end
