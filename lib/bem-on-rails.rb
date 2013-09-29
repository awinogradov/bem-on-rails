require "bem-on-rails/version"
require "bem-on-rails/engine"
require "bem-on-rails/build/bem_names"
require "bem-on-rails/build/console_messages"
require "bem-on-rails/build/levels"
require "bem-on-rails/generators/install_generator"
require 'bem-on-rails/railtie' if defined?(Rails)

module Bemonrails
end
