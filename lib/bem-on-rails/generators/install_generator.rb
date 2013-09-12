require 'rails/generators'

module Bemonrails
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates/", __FILE__)

      def add_render_helpers
        app_helper = 'app/helpers/application_helper.rb'
        first_string = "module ApplicationHelper"
        bem_render_helpers = "\n\t# Add BEM blocks rendering helpers\n\tinclude Bemonrails::BemRenderHelper\n"

        insert_into_file app_helper, bem_render_helpers, :after => first_string
      end

      def add_blocks_folder
        app_controller = 'app/controllers/application_controller.rb'
        protection_str = "protect_from_forgery\n"
        bem_block_folder = "\n\t# Add BEM blocks folder to default views scope\n\tbefore_filter { prepend_view_path(BEM[:blocks][:dir]) }\n"

        insert_into_file app_controller, bem_block_folder, :after => protection_str
      end

      def add_initializer
        template "config/initializer.tt.rb", File.join(Rails.root, "config", "initializers", "bem.rb")
      end

      def install_bem_tasks
        template "thor/bem.tt.rb", File.join(Rails.root, "lib", "tasks", "bem.thor")
      end

      def add_blocks_templates
        %w(haml.tt coffee.tt md.tt sass.tt).each do |t|
          template "techs/#{t}", File.join(Rails.root, "lib", "tasks", "templates", t)
        end
      end

    end
  end
end
