require 'bem-on-rails/bem_render_helper'

module Bemonrails
    class Railtie < Rails::Railtie

        initializer "railtie.configure_rails_initialization" do
            require 'bem-on-rails/initializers/bem'
        end

        ActiveSupport.on_load :action_view do
            include Bemonrails::BemRenderHelper
        end

        ActiveSupport.on_load :action_controller do
            include Bemonrails::Levels
            before_filter :parse_bem_levels
        end

    end

end
