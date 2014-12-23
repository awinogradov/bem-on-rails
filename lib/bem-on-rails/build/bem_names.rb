module Bemonrails
  module BemNames
    # Resolve directories
    def build_path_for(essence, builder=options, include_level=true)
      current_level = builder[:level] ? builder[:level] : BEM[:level]
      path = include_level ? [current_level] : []

      case essence
      when :mod
        # This is for mods with value
        if builder[:block] && builder[:element]
          path.push path_m(:element)
        elsif builder[:block]
          path.push path_m(:block)
        else
          raise print_message("Mods must be for block or element.", 'red')
        end
      when :element
        path.push path_e(builder[:block], builder[:element])
      when :block
        path.push build_b(builder[:block])
      else
        raise print_message("Unknown params. Try 'thor help bem:create'", 'red')
      end

      File.join path.compact
    end

    def generate_klass(builder=options)
      names = {}

      # Generate names for block, his mods and they values
      if builder[:block]

        names[:klass] = build_b(builder[:block])

        # If block have mods
        names[:klass] = build_m(builder[:block], nil, builder[:mod], builder[:value]) if builder[:mod]
      end

      # Generate names for elements, they mods and they values
      if builder[:element]

        names[:klass] = build_e(builder[:block], builder[:element])

        # If element have mods
        names[:klass] = build_m(builder[:block], builder[:element], builder[:mod], builder[:value]) if builder[:mod]
      end

      names
    end

    def resolve_essence
      essence = :block

      if options[:element]
        essence = :element
        if options[:mod]
          essence = :mod
        end
      end

      essence
    end

    def path_l(path, level=options[:level])
        File.join Rails.root.join(BEM[:root], level, path)
    end

    # Build block name
    def build_b(b=options[:block])
      BEM[:blocks][:prefix] + b
    end

    # Build block path
    def path_e(b=options[:block], e=options[:element])
      File.join build_b(b), BEM[:elements][:dir], BEM[:elements][:prefix] + e
    end

    # Build element name
    def build_e(b=options[:block], e=options[:element])
      b + BEM[:elements][:prefix] + e
    end

    def path_m(essence, m=options[:mod])
      case essence
      when :element
        File.join path_e, build_e, BEM[:mods][:dir], BEM[:mods][:prefix] + m
      else
        File.join build_b, BEM[:mods][:dir], BEM[:mods][:prefix] + m
      end
    end

    def mod(b=options[:block], e=options[:element], m=options[:mod], v=options[:value])
        name = b
        name = name + element(b, e) if e
        name = name + BEM[:mods][:prefix] + m
        name = name + BEM[:mods][:postfix] + v if v
    end

    def template_exists?(file)
      BEM[:techs].each do |tech, ext|
        if File.exists? file + ext
          return true
        end
      end
    end
  end
end
