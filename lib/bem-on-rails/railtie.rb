module Bemonrails
    class Railtie < Rails::Railtie
        initializer "railtie.configure_rails_initialization" do
            require 'bem-on-rails/initializers/bem'
        end

        ActiveSupport.on_load :action_view do
            include Bemonrails::BemRenderHelper
        end

        ActiveSupport.on_load :action_controller do
            before_filter { prepend_view_path(BEM[:lib]) }
        end
    end

end