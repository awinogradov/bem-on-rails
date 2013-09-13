module Bemonrails
  module BemNames
    # Directories paths.
    def build_path_for(essence, builder=options)
      # I think all block can be in groups
      path = [builder[:group]]
      case essence
      when :mod
        # This is for mods with value
        if builder[:block] && builder[:element] && builder[:value]
          path.push(mod_directory(:element), mod)
        elsif builder[:block] && builder[:value]
          path.push(mod_directory(:block), mod)
          # This is for mods without value
        elsif builder[:block] && builder[:element]
          path.push(mod_directory(:element))
        elsif builder[:block]
          path.push(mod_directory(:block))
        else
          raise print_message("Mods must be for block or element.", 'red')
        end
      when :element
        path.push(element_directory)
      when :block
        # Yea! Do nothing!
      else
        raise print_message("Unknown params. Try 'thor help bem:create'", 'red')
      end
      File.join(path.compact)
    end

    def path_to_block(path)
      BEM[:blocks][:path] + path
    end

    def generate_names(builder=options)
      names = {}
      # Generate names for block, his mods and they values
      if builder[:block]

        names[:klass] = names[:name] = block

        if builder[:mod]
          names[:name] = mod
          names[:klass] = block + names[:name]
        end

        if builder[:value]
          names[:name] =  mod(builder[:value])
          names[:klass] = block + mod + names[:name]
        end
      end

      # Generate names for elements, his mods and they values
      if builder[:element]

        names[:name] = element
        names[:klass] += names[:name]

        if builder[:mod]
          names[:name] = mod
          names[:klass] = block + element + names[:name]
        end

        if builder[:value]
          names[:name] =  mod(builder[:value])
          names[:klass] = block + element + mod + names[:name]
        end
      end

      names
    end

    def essence
      if options[:block] && !options[:element] && !options[:mod]
        :block
      elsif options[:element] && !options[:mod]
        :element
      elsif options[:mod]
        :mod
      end
    end

    def block(name=options[:block])
      BEM[:blocks][:prefix] + name
    end

    def element_directory
      block_name = @block_name ? @block_name : options[:block]
      File.join(block(block_name), BEM[:elements][:dir])
    end

    def element(name=options[:element])
      BEM[:elements][:prefix] + name
    end

    def mod_directory(essence)
      case essence
      when :block
        File.join(block, BEM[:mods][:dir])
      when :element
        File.join(element_directory, element, BEM[:mods][:dir])
      else
        File.join(block, BEM[:mods][:dir])
      end
    end

    def mod(name= options[:mod], value=false)
      if value
        BEM[:mods][:prefix] + value
      else
        BEM[:mods][:prefix] + name
      end
    end

    def template_exists?(file)
      BEM[:techs].each do |tech, extension|
        if File.exists? file + extension
          return true 
        end
      end
    end
  end
end
