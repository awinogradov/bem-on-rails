module Bemonrails
    module Levels        
        def parse_bem_levels
            BEM[:levels].each do |level|
                prepend_view_path File.join(BEM[:root] , level[:name])
            end
            prepend_view_path BEM[:root] 
        end
    end
end