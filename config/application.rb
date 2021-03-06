require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OscarMEDashboard
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    # config.middleware.use Apartment::Elevators::Subdomain
    # config.middleware.insert_before Warden::Manager, Apartment::Elevators::Subdomain
    config.autoload_paths << Rails.root.join('lib')
    config.hosts.clear

    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :km]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.time_zone = "Asia/Bangkok"
    # config.exceptions_app = self.routes

    config.generators.system_tests = nil
    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, fixture: false
      g.fixture_replacement :factory_bot
      g.factory_bot     suffix: "factory"
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.channel         assets: false
      g.jbuilder        false
    end

    config.exceptions_app = self.routes
    ActiveStorage::Engine.config.active_storage.content_types_to_serve_as_binary.delete('image/svg+xml')
  end
end
