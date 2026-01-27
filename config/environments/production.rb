require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here take precedence over config/application.rb

  # Code is not reloaded between requests
  config.enable_reloading = false

  # Eager load code on boot for better performance
  config.eager_load = true

  # Full error reports disabled
  config.consider_all_requests_local = false

  # Disable caching completely
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Cache assets for far-future expiry
  config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{1.year.to_i}" }

  # Store uploaded files locally
  config.active_storage.service = :local

  # Assume all access is through SSL-terminating reverse proxy
  config.assume_ssl = true
  config.force_ssl = true

  # Logging
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Silence health check requests
  config.silence_healthcheck_path = "/up"

  # Suppress deprecation notices
  config.active_support.report_deprecations = false

  # Active Job (background jobs) run inline (synchronously)
  config.active_job.queue_adapter = :inline

  # Action Cable (WebSockets) disabled
  config.action_cable.mount_path = nil
  config.action_cable.url = nil
  config.action_cable.allowed_request_origins = []

  # Mailer settings (example)
  config.action_mailer.default_url_options = { host: "example.com" }

  # Enable locale fallbacks
  config.i18n.fallbacks = true

  # Do not dump schema after migrations
  config.active_record.dump_schema_after_migration = false

  # Only use :id for object inspections
  config.active_record.attributes_for_inspect = [:id]

  # Host protection (optional)
  # config.hosts = ["example.com", /.*\.example\.com/]
end

