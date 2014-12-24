require 'rails/generators'

module Bemonrails
    module Generators
        class InstallGenerator < ::Rails::Generators::Base

            source_root File.expand_path("../templates/", __FILE__)

            def initializers
                template "config/initializer.tt.rb", File.join(Rails.root, "config", "initializers", "bem.rb")
            end

            def tasks
                template "thor/bem.tt.rb", File.join(Rails.root, "lib", "tasks", "bem.thor")
            end

            def templates
                %w(haml.tt coffee.tt md.tt sass.tt).each do |t|
                    copy_file "techs/#{t}", File.join(Rails.root, "lib", "tasks", "templates", t)
                end
            end

        end

    end

end
