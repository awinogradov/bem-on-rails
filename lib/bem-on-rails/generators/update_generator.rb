require 'rails/generators'

module Bemonrails
  module Generators
    class UpdateGenerator < ::Rails::Generators::Base

    	def update_bem_tasks
    		puts "Do you wish to update BEM thor tasks [y/N]?"
    		`thor update bem`
    	end

    end
  end
end