require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Reload code without server restart
  config.enable_reloading = true
  config.eager_load = false

  # Full error reports
  config.consider_all_requests_local = true
  config.server_timing = true

  # Emails (Gmail SMTP)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  # Use Ngrok URL if set, otherwise localhost
  ngrok_host = ENV.fetch("NGROK_URL", "localhost")
  Rails.application.routes.default_url_options[:host] = ngrok_host
  Rails.application.routes.default_url_options[:protocol] = "https"
  config.action_mailer.default_url_options = {
    host: ngrok_host,
    protocol: "https"
  }

  # Gmail SMTP settings
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "gmail.com",
    user_name:            ENV["GMAIL_USERNAME"],
    password:             ENV["GMAIL_PASSWORD"],
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # Caching setup
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
  end
  config.cache_store = :memory_store

  # Local storage for uploads
  config.active_storage.service = :local

  # Deprecation warnings
  config.active_support.deprecation = :log

  # Migrations
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true

  # Background jobs
  config.active_job.queue_adapter = :async
  config.active_job.verbose_enqueue_logs = true

  # Views
  config.action_view.annotate_rendered_view_with_filenames = true

  # Controllers
  config.action_controller.raise_on_missing_callback_actions = true

  # Allow Ngrok hosts
  config.hosts << /[a-z0-9\-]+\.ngrok-free\.app/
end
