module Bemonrails
  module BemRenderHelper
    include Bemonrails::BemNames

    def bemtag
      @custom_tag ||= "div"
    end

    def render_block(name, builder={})
      unless name.blank?
        # Generate block paths
        path = File.join BEM[:blocks][:dir], build_path_for(:block, builder)
        target = File.join path, block(name), block(name)
        # Block details
        @block_name = name
        @block_mods = builder[:mods]
        @custom_attrs = builder[:attrs]
        @custom_class = builder[:cls]
        @custom_tag = builder[:tag]
        @content = builder[:content]
        # Render block in view  
        template_exists?(target) ? render(file: target) : bemempty
      end
    end
    alias :b :render_block

    def render_element(name, builder={})
      unless name.blank?
        # Generate element paths
        path = File.join build_path_for(:element, builder)
        target = File.join path, element(name), element(name)
        # Element details
        @element_name = name
        @element_mods = builder[:elemMods]
        @custom_attrs = builder[:attrs]
        @custom_class = builder[:cls]
        @custom_tag = builder[:tag]
        puts @element_mods
        @content = builder[:content]
        # Render element in block
        template_exists?(target) ? render(file: target) : bemempty
      end
    end
    alias :e :render_element

    def render_bemattributes
      if @block_name && !@element_name 
        classes_array = [ block(@block_name) ]
        # Install mods
        if @block_mods
          @block_mods.each do |mod|
            # Generate mods classes
            if mod.kind_of? Hash
              mod.each do |mod_name, mod_value|
                classes_array.push block(@block_name) + mod(mod_name.to_s) + mod(mod_name.to_s, mod_value)
              end
            else
              classes_array.push block(@block_name) + mod(mod.to_s)
            end
            # TODO: Find mod with restructure .haml, .erb or etc.
          end 
        end
      elsif @element_name 
        classes_array = [ block(@block_name) + element(@element_name) ]
        # Install mods
        if @element_mods
          @element_mods.each do |mod_name, mod_value|
            # Generate mods classes
            if mod_value
              classes_array.push block(@block_name) + element(@element_name) + mod(mod_name.to_s) + mod(mod_name.to_s, mod_value)
            else
              classes_array.push block(@block_name) + element(@element_name) + mod(mod_name.to_s)
            end
          end 
        end
      end

      bemclass = classes_array.join(" ")

      # If custom class exist
      if @custom_class
        bemclass = [bemclass, @custom_class].join(" ")
      end

      # String for tag attributes
      bemattributes = { class: bemclass }

      # If custom attributes exist
      if @custom_attrs
        bemattributes.merge! @custom_attrs
      end

      bemattributes
    end
    alias :bemattrs :render_bemattributes

    def render_empty
      "<div class=#{ bemclass }></div>".html_safe
    end
    alias :bemempty :render_empty

    def render_content
      render "bemonrails/essences/content"
    end
    alias :bemcontent :render_content
  end
end
