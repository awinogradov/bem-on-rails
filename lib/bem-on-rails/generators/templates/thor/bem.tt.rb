require File.expand_path('config/environment.rb')

class Bem < Thor
    include Thor::Actions
    include Bemonrails::BemNames

    source_root File.expand_path('../templates', __FILE__)

    desc 'create', 'Create block, element or mod'
    method_option :block, type: :string, aliases: "-b", desc: "Create block in default techs."
    method_option :element, type: :string, aliases: "-e", desc: "Create element in default techs. Use with block param."
    method_option :mod, type: :string, aliases: "-m", desc: "Create modificator for block or element."
    method_option :value, type: :string, aliases: "-v", desc: "Value for modificator."
    method_option :tech, type: :string, aliases: "-T", desc: "Create essence in spec tech."
    method_option :group, type: :string, aliases: "-G", desc: "Create essence in group. Work for blocks only!"
    method_option :force, type: :boolean, desc: "Force existing block, element or mod files."
    def create
        path = build_path_for(essence)
        manipulate_essence(:create, essence, path)
    end


    desc 'remove', 'Remove block, element or mod'
    method_option :block, type: :string, aliases: "-b", desc: "Remove block in default techs."
    method_option :element, type: :string, aliases: "-e", desc: "Remove element in default techs. Use with block param."
    method_option :mod, type: :string, aliases: "-m", desc: "Remove modificator for block or element."
    method_option :value, type: :string, aliases: "-v", desc: "Value for modificator."
    method_option :tech, type: :string, aliases: "-T", desc: "Remove essence in spec tech."
    method_option :group, type: :string, aliases: "-G", desc: "Remove essence in group. Work for blocks only!"
    def remove
        path = build_path_for(essence)
        manipulate_essence(:remove, essence, path)
    end


    desc 'usage', 'Essence usage information'
    method_option :block, type: :string, aliases: "-b", desc: "Block usage."
    method_option :element, type: :string, aliases: "-e", desc: "Element usage"
    method_option :mod, type: :string, aliases: "-m", desc: "Mod usage."
    method_option :value, type: :string, aliases: "-v", desc: "Mod value usage."
    method_option :group, type: :string, aliases: "-G", desc: "Search essence in group."
    def usage
        path = build_path_for(essence)
        manipulate_essence(:usage, essence, path)
    end


    desc 'list', 'See list of group, block elements, mods and etc.'
    method_option :block, type: :string, aliases: "-b", desc: "All block elements, mods and mods values"
    method_option :element, type: :string, aliases: "-e", desc: "All element mods and mods values"
    method_option :mod, type: :string, aliases: "-m", desc: "All mod values."
    method_option :group, type: :string, aliases: "-G", desc: "All blocks in group."
    def list
        path = essence ? build_path_for(essence) : build_path_for(:block)
        case essence
            when :block
                print_elements_list(block, path)
                print_mods_list(block, path)
            when :element
                print_mods_list(element, path)
            when :mod
                print_values_list(element, path)
            else
                print_blocks_list(path)
        end
    end






    protected

    def essence_exist?(essence_dir, creating=true)
        if File.directory?(File.join(BEM[:blocks][:path], essence_dir))
            puts print_message("Essence with this name is already exists. Try 'thor help bem:list' or 'thor help bem:usage ", 'red') if creating
            true
        end
    end

    def create_essence(essence_options, path)
        names = generate_names
        @css_class = '.' + names[:klass]
        # If you need more templates. Please create them into templates
        # directory. Watch existing templates for example.
        # What is .tt? It is custom extension for finding templates in other files.
        if options[:tech] # Maybe recive from command line
            template "#{options[:tech]}.tt", File.join(essence_options[:path], path, names[:name], names[:name] + BEM[:techs][options[:tech].to_sym])
        else
            # You can customize this list of defaults. See on top of file.
            BEM[:default].each do |tech, extension|
                template "#{tech}.tt", File.join(essence_options[:path], path, names[:name], names[:name] + extension)
            end
        end
    end

    def remove_essence(essence_options, path)
        names = generate_names

        if options[:tech]
            destination = File.join(essence_options[:path], path, names[:name], names[:name] + BEM[:techs][options[:tech].to_sym])
            FileUtils.rm(destination)
        else
            destination = File.join(essence_options[:path], path, names[:name])
            FileUtils.rm_rf(destination)
        end

        puts "\e[0;31m      remove\e[0m  " + destination.to_s.gsub(Rails.root.to_s + "/", "")
    end

    def update_assets(name, path)
        BEM[:assets].each do |type, tech|
            asset = File.join(Rails.root, "app", "assets", type.to_s, "application" + tech[:ext])
            destination = [path, name, name + tech[:ext]].reject(&:empty?)
            line = "#{tech[:import]} #{File.join(destination)}#{tech[:postfix]}"
            File.open(asset, "a") do |f|
                f.write("\n" + line)
            end
        end
    end

    def cut_assets(name, path)
        BEM[:assets].each do |type, tech|
            asset = File.join(Rails.root, "app", "assets", type.to_s, "application" + tech[:ext])
            destination = [path, name, name + tech[:ext]].reject(&:empty?)
            line = "#{tech[:import]} #{File.join(destination)}#{tech[:postfix]}"

            # Open temporary file
            tmp = Tempfile.new("temp")
            # Write good lines to temporary file.
            open(asset, 'r').each do |l|
                tmp << l unless l.chomp == line || l.empty?
            end
            # Close tmp, or troubles ahead.
            tmp.close
            # Temp to original.
            FileUtils.mv(tmp.path, asset)
        end
    end

    def search_usage_information(essence, path)
        BEM[:usage].each do |tech, extension|
            file_destination = File.join(BEM[:blocks][:path] + path, essence, essence + extension)
            if File.exist?(file_destination)
                puts tech.to_s + ": " + file_destination
                puts "BEM[:usage]:\t"
                File.readlines(file_destination).each do |line|
                    puts line
                end
            end
        end
    end

    def print_blocks_list(essence="", path)
        directory_destination = File.join(BEM[:blocks][:path] + path, essence)
        puts directory_destination
        print_message("BEM[:blocks]:\t", 'green')
        Dir[directory_destination + "/*"].each do |name|
            # Show only essences. No files. No groups.
            # Essences have't ext.
            # Get dir name.
            name = name.split('/')[-1]
            if name.split('.').size == 1
                puts " - " + name
            end
        end
    end

    def print_elements_list(essence="", path)
        directory_destination = File.join(BEM[:blocks][:path] + path, essence, BEM[:elements][:dir])
        print_message("BEM[:elements]:\t", 'purple')
        Dir[directory_destination + "/*"].each do |name|
            # Get dir name.
            name = name.split('/')[-1]
            puts " - " + name.split(BEM[:elements][:prefix])[1]
        end
    end

    def print_mods_list(essence="", path)
        directory_destination = File.join(BEM[:blocks][:path] + path, essence, BEM[:mods][:dir])
        print_message("BEM[:mods]:\t", 'cyan')
        Dir[directory_destination + "/*"].each do |name|
            # Get dir name.
            name = name.split('/')[-1]
            puts " - " + name.split(BEM[:mods][:prefix])[1]
        end
    end

    def print_values_list(essence="", path)
        directory_destination = File.join(BEM[:blocks][:path] + path, essence)
        print_message("VALUES:\t", 'yellow')
        Dir[directory_destination +  "/*"].each do |name|
            # Get dir name.
            name = name.split('/')[-1]
            puts " - " + name.split(BEM[:mods][:prefix])[1]
        end
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

    def manipulate_essence(action, ess, path)
        if ess == :mod
            ess_name = mod(options[:value] ? options[:value] : options[:mod])
            destination = File.join(path, ess_name)
        else
            ess_name = send(ess)
            destination = File.join(path, ess_name)
        end

        case action
            when :create
                unless essence_exist?(destination)
                    create_essence(BEM[ess.to_s.pluralize.to_sym], path)
                    update_assets(ess_name, path)
                end
            when :remove
                if essence_exist?(destination, false) # Don't show error
                    remove_essence(BEM[ess.to_s.pluralize.to_sym], path)
                    cut_assets(ess_name, path)
                end
            when :usage
                search_usage_information(ess_name, path) if essence_exist?(destination, false)
            else
                raise print_message("You should set params. Try 'thor help bem:#{action}' for more information", 'red')
        end
    end

    def print_message(message, color)
        check_argument_data_type(message, String)
        check_argument_data_type(color, String)

        color = case color
                    when 'green' then "\e[0;32m"
                    when 'red' then "\e[0;31m"
                    when 'blue' then "\e[0;34m"
                    when 'cyan' then "\e[0;36m"
                    when 'purple' then "\e[0;35m"
                    when 'yellow' then "\e[1;33m"
                    else ''
                end

        puts "#{color + message} \e[0m"
    end

    def check_argument_data_type(argument, type)
        raise print_message("#{argument} must be a #{type.to_s}", 'red') unless argument.kind_of? type
    end
end