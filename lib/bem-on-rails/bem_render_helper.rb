module Bemonrails
  module BemRenderHelper
    include Bemonrails::BemNames

    def b(b_name, builder={})
      unless b_name.blank?
        builder[:block] = b_name
        path = File.join path_resolve(:block, builder, false)
        target = File.join path, build_b(b_name)
        create_ctx builder
        update_ctx :block, b_name
        resolve_ctx
        template_exists?(target) ? render(file: target) : empty
      end
    end

    def e(e_name, builder={})
      unless e_name.blank?
        path = File.join path_resolve(:element, builder, false)
        target = File.join path, build_e(e_name), build_e(@this[:block], e_name)
        create_ctx builder
        update_ctx :element, e_name
        resolve_ctx
        template_exists?(target) ? render(file: target) : empty
      end
    end

    def create_ctx(builder={})
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

    def update_ctx(essence, name)
      case essence
      when :block
        @this[:block] = @block_buffer = name
      when :element
        @this[:block] = @block_buffer
        @this[:elem] = name
      end
    end

    def resolve_ctx
      classes_array = []

      if @this[:bem] == true
        generate_class(@this, classes_array)
        resolve_mixes(@this[:mix], classes_array)
      else
        classes_array.push(@this[:elem] ? @this[:elem] : @this[:block])
      end

      @this[:attrs].merge!({class: [classes_array, @this[:cls]].join(" ").strip!})
    end

    def resolve_mods(mods, classes_array, bl, el=false)
      mods.each do |m, v|
        classes_array.push(build_m(build_b(bl), el ? build_e(bl, el) : nil, m.to_s, v))
      end
    end

    def resolve_mixes(mixs, classes_array)
      mixs.each do |mix|
        generate_class(mix, classes_array)
      end
    end

    def generate_class(essence, classes_array)
      if essence[:block]
        classes_array.push(build_b(essence[:block]))
        resolve_mods(essence[:mods], classes_array, essence[:block])
      elsif essence[:block] && essence[:elem]
        classes_array.push(build_e(essence[:block], essence[:elem]))
        resolve_mods(essence[:elemMods], classes_array, essence[:block], essence[:elem])
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
