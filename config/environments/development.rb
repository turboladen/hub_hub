HubHub::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.ember.variant = :develop

  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    #Bullet.growl = true
    #Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
    #  :password => 'bullets_password_for_jabber',
    #  :receiver => 'your_account@jabber.org',
    #  :show_online_status => true }
    Bullet.rails_logger = true
    #Bullet.airbrake = true

    # Have Mini Profiler show up on the right
    Rack::MiniProfiler.config.position = 'right'
    # Have Mini Profiler start in hidden mode - display with short cut (defaulted to 'Alt+P')
    # Rack::MiniProfiler.config.start_hidden = true
    # Don't collect backtraces on SQL queries that take less than 5 ms to execute
    # (necessary on Rubies earlier than 2.0)
    # Rack::MiniProfiler.config.backtrace_threshold_ms = 5
  end
end
