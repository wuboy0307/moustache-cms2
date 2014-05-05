require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"
require "ostruct"

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.

if defined?(Bundler)
  Bundler.require *Rails.groups(:assets => %w(development test))
end

module MoustacheCms
  class Application < Rails::Application 
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += Dir["#{config.root}/lib/**/"] 

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Eastern Time (US & Canada)' 

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.precompile += %w(login_focus.js ace_editor.js)
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.domain = "example.com"

    # Configure generators values. Many other options are available, be sure to check the documentation.  
    config.generators do |g|  
      g.template_engine :haml
      g.test_framework :rspec
      g.stylesheets false  
    end
    
    # Add this for Spork 
    if Rails.env.test?
      initializer :after => :initialize_dependency_mechanism do 
        ActiveSupport::Dependencies.mechanism = :load
      end
    end

  # path to read assets from
    config.theme_asset_path = "#{Rails.root}/vendor/assets/*/#{self.name}/*"

    # compile theme assets
    # config.theme_css = "**/moustache.css"
    # config.assets.precompile += [MoustacheCms::Application.config.theme_css]

  end
end
