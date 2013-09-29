module Bemonrails
    module Levels        
        def parse_bem_levels
            root = BEM[:root] 
            BEM[:levels].each do |level|
                prepend_view_path File.join(root, level[:name])
            end
            prepend_view_path root
        end
    end
end