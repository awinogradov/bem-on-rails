module Bemonrails

    class Railtie < Rails::Railtie
        ActiveSupport.on_load :action_view do
            include Bemonrails::BemRenderHelper
        end

        ActiveSupport.on_load :action_controller do
            before_filter { prepend_view_path(BEM[:blocks][:dir]) }
        end
    end

end