module Bemonrails
  module BemRenderHelper
    include Bemonrails::BemNames

    def b(name, builder={})
      unless name.blank?
        path = File.join BEM[:blocks][:dir], build_path_for(:block, builder)
        target = File.join path, block(name), block(name)
        get_bemattributes_from builder
        set_names :block, name
        then_generate_bemclass
        template_exists?(target) ? render(file: target) : empty
      end
    end

    def e(name, builder={})
      unless name.blank?
        path = File.join build_path_for(:element, builder)
        target = File.join path, element(name), element(name)
        get_bemattributes_from builder
        set_names :element, name
        then_generate_bemclass
        template_exists?(target) ? render(file: target) : empty
      end
    end

    def get_bemattributes_from(builder={})
      @this = {}
      BEM[:attrs].each do |mod|
        if builder[mod]
          @this[mod] = builder[mod] 
          builder = builder.except(mod)
        end
      end
      @this[:ctx] = builder
      # Set defult attrs, if user not set them.
      @this[:tag] ||= :div
      @this[:attrs] ||= {}
    end

    def set_names(essence, name)
      case essence
      when :block
        @this[:block] = @block_buffer = name
      when :element
        @this[:block] = @block_buffer
        @this[:elem] = name
      end
    end

    def then_generate_bemclass
      if @this[:block] && !@this[:elem]
        classes_array = [block(@this[:block])]
        install_mods(@this[:mods], classes_array)
      elsif @this[:elem] 
        classes_array = [block(@this[:block]) + element(@this[:elem])]
        install_mods(@this[:elemMods], classes_array)
      end
      @this[:attrs].merge!({class: [classes_array, @this[:cls]].join(" ").strip!})
    end

    def install_mods(mods, classes_array)
      if mods
        el = @this[:elem] ? element(@this[:elem]) : ""
        mods.each do |mod|
          if mod.kind_of? Hash
            mod.each do |mod_name, mod_value|
              classes_array.push block(@this[:block]) + el + mod(mod_name.to_s) + mod(mod_name.to_s, mod_value)
            end
          else
            classes_array.push block(@this[:block]) + el + mod(mod.to_s)
          end  
        end 
      end
    end

    def empty
      "<div class=#{ @this[:attrs][:class] }></div>".html_safe
    end

    def this
      @this
    end

    def content
      render "bemonrails/essences/content"
    end
  end
end
