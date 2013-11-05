module Bemonrails
  module BemRenderHelper
    include Bemonrails::BemNames

    def b(name, builder={})
      unless name.blank?
        path = File.join build_path_for(:block, builder, false)
        target = File.join path, block(name), block(name)
        get_bemattributes_from builder
        set_names :block, name
        update_bemattributes
        template_exists?(target) ? render(file: target) : empty
      end
    end

    def e(name, builder={})
      unless name.blank?
        path = File.join build_path_for(:element, builder, false)
        target = File.join path, element(name), element(name)
        get_bemattributes_from builder
        set_names :element, name
        update_bemattributes
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
      @this[:bem] ||= true
      @this[:attrs] ||= {}
      @this[:tag] ||= :div
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

    def update_bemattributes
      classes_array = []
      if @this[:bem] == true
        generate_class(@this, classes_array)
        install_mix(@this[:mix], classes_array)
      else
        classes_array.push(@this[:elem] ? @this[:elem] : @this[:block])
      end
      @this[:attrs].merge!({class: [classes_array, @this[:cls]].join(" ").strip!})
    end

    def install_mods(mods, classes_array, bl, el=false)
      if mods
        el = el ? element(el) : ""
        mods.each do |mod|
          if mod.kind_of? Hash
            mod.each do |mod_name, mod_value|
              classes_array.push(block(bl) + el + mod(mod_name.to_s) + mod(mod_name.to_s, mod_value))
            end
          else
            classes_array.push(block(bl) + el + mod(mod.to_s))
          end  
        end 
      end
    end

    def install_mix(mixs, classes_array)
      if mixs
        mixs.each do |mix|
          generate_class(mix, classes_array) 
        end   
      end
    end

    def generate_class(essence, classes_array)
      if essence[:block] && !essence[:elem]
        classes_array.push(block(essence[:block]))
        install_mods(essence[:mods], classes_array, essence[:block])
      elsif essence[:elem] 
        classes_array.push(block(essence[:block]) + element(essence[:elem]))
        install_mods(essence[:elemMods], classes_array, essence[:block], essence[:elem])
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
