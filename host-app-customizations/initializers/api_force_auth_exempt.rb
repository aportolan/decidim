# frozen_string_literal: true

# Allow the GraphQL API endpoint (and API session endpoints) to be reached
# even when the organization enables force-authentication.
#
# The Decidim API handles its own authentication (JWT / API key+secret) and is
# intended to be reachable by machine-to-machine clients. Without this, the
# org-level force-auth redirects /api to the sign-in page before the API auth
# can run, breaking API integrations.
Rails.application.config.to_prepare do
  module ApiForceAuthExempt
    def unauthorized_paths
      super + %w[/api /api/sign_in /api/sign_out /graphiql]
    end
  end

  Decidim::ForceAuthentication.prepend(ApiForceAuthExempt)
end
