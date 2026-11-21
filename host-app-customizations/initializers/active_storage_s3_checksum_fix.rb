# frozen_string_literal: true

# Cloudflare R2 compatibility for Active Storage (direct uploads + display).
Rails.application.config.to_prepare do
  require "aws-sdk-s3"
  require "active_storage/service/s3_service"

  Aws.config.update(
    request_checksum_calculation: "when_required",
    response_checksum_validation: "when_required"
  )

  # Decidim's direct-upload XHR posts to ActiveStorage::DirectUploadsController,
  # which inherits protect_from_forgery. The upload modal does not send the
  # standard Rails CSRF token, yielding InvalidAuthenticityToken -> 422.
  # Uploads are already user-session authenticated, so skip the CSRF check.
  if defined?(::ActiveStorage::DirectUploadsController)
    ::ActiveStorage::DirectUploadsController.class_eval do
      skip_before_action :verify_authenticity_token, raise: false
    end
  end
end

# Allow browser direct-uploads + asset serving to/from the R2 bucket through
# Decidim's Content-Security-Policy (the default connect-src / img-src only
# allow 'self' and hereapi.com). Without this, direct uploads to R2 are blocked
# by the browser CSP and fail with a network error (status 0).
R2_HOST = ENV.fetch("AWS_ENDPOINT", "").sub(%r{^https?://}, "")
if R2_HOST.present?
  Decidim.config.content_security_policies_extra = {
    "connect-src" => ["https://#{R2_HOST}"],
    "img-src" => ["https://#{R2_HOST}"]
  }
end
