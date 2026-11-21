# frozen_string_literal: true

# Workaround for Decidim::Env not defining #to_str. When an OmniAuth provider
# (Facebook, Google, Twitter) is configured via ENV vars, Decidim.omniauth_providers
# keeps app_id/app_secret/client_id/client_secret as Decidim::Env objects, which
# leak into the OmniAuth strategy options. omniauth-oauth2 then performs an
# implicit String conversion and raises:
#   "No implicit conversion of Decidim::Env into string"
# Defining #to_str (implicit conversion) resolves the object to its ENV value.
module Decidim
  class Env
    def to_str
      value.to_s
    end
  end
end
