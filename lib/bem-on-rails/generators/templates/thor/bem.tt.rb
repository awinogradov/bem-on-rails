require File.expand_path('config/environment.rb')

class Bem < Thor
    include Thor::Actions
    include Bemonrails::BemNames
    include Bemonrails::ConsoleMessages

    source_root File.expand_path('../templates', __FILE__)

    desc 'create', 'Create block, element or mod'
    method_option :block, type: :string, aliases: "-b", desc: "Create block in default techs."
    method_option :element, type: :string, aliases: "-e", desc: "Create element in default techs. Use with block param."
    method_option :mod, type: :string, aliases: "-m", desc: "Create modificator for block or element."
    method_option :value, type: :string, aliases: "-v", desc: "Value for modificator."
    method_option :tech, type: :string, aliases: "-T", desc: "Create essence in spec tech."
    method_option :level, type: :string, aliases: "-l", desc: "Create essence in level. Work for blocks only!"
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
    method_option :level, type: :string, aliases: "-l", desc: "Remove essence in level. Work for blocks only!"
    def remove
        path = build_path_for(essence)
        manipulate_essence(:remove, essence, path)
    end


    desc 'usage', 'Essence usage information'
    method_option :block, type: :string, aliases: "-b", desc: "Block usage."
    method_option :element, type: :string, aliases: "-e", desc: "Element usage"
    method_option :mod, type: :string, aliases: "-m", desc: "Mod usage."
    method_option :value, type: :string, aliases: "-v", desc: "Mod value usage."
    method_option :level, type: :string, aliases: "-l", desc: "Search essence in level."
    def usage
        path = build_path_for(essence)
        manipulate_essence(:usage, essence, path)
    end


    desc 'list', 'See list of level, block elements, mods and etc.'
    method_option :block, type: :string, aliases: "-b", desc: "All block elements, mods and mods values"
    method_option :element, type: :string, aliases: "-e", desc: "All element mods and mods values"
    method_option :mod, type: :string, aliases: "-m", desc: "All mod values."
    method_option :level, type: :string, aliases: "-l", desc: "All blocks in level."
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

    desc 'levels', 'Manipulating with levels'
    method_option :add, type: :boolean, aliases: "-a", desc: "Add new level"
    method_option :git, type: :string, aliases: "-g", desc: "From git repository"
    method_option :dir, type: :string, aliases: "-d", desc: "From local directory"
    method_option :new, type: :string, aliases: "-n", desc: "Create new level"
    method_option :default, type: :string, desc: "Create default level tree"
    def levels
        if options[:add]
            level_name = ""
            level = ""
            if options[:git]
                level_name = options[:git].split("/").last.gsub(".git", "")
                level = Rails.root.join BEM[:root], level_name
                print_message("Cloning blocks into new level: #{ level_name }...", "green")
                `git clone #{ options[:git] } #{ level }`
                test_level(level) ? level_added : level_error
                level_has_assets?(level) ? update_assets_with_level(level_name) : make_level_assets_path(level)
            elsif options[:dir]
                level_name = options[:git].split("/").last
                level = Rails.root.join BEM[:root], level_name
                print_message("Copying blocks into new level: #{ level_name }...", "green")
                `cp -R #{ options[:dir] } #{ level }`
                test_level(level) ? level_added : level_error
                level_has_assets?(level) ? update_assets_with_level(level_name) : make_level_assets_path(level)
            elsif options[:new]
                level_name = options[:new]
                level = Rails.root.join BEM[:root], level_name
                make_level_assets_path level
                update_assets_with_level level_name
                test_level(level) ? level_added : level_error
            elsif options[:default]
                level_name = BEM[:app]
                level = Rails.root.join BEM[:root], level_name
                make_level_assets_path level
                update_assets_with_level level_name
                test_level(level) ? level_added : level_error
            end
        end
    end

    protected

    def test_level(level)
        File.directory? level
    end

    def level_added
        print_message("New level added successfully! Change BEM[:levels] in bem.rb for available levels.", "green")
    end

    def level_error
        print_message("Error! We have a trouble with connection to repository. Please, try again.", "red")
    end

    def level_assets_path
        File.join(".bem", "assets")
    end

    def level_has_assets?(level)
        File.directory? File.join level, level_assets_path
    end

    def update_assets_with_level(level)
        BEM[:assets].each do |type, tech|
            asset = File.join(Rails.root, "app", "assets", type.to_s, "application" + tech[:ext])
            destination = [level, level_assets_path, type.to_s, "level" + tech[:ext]]
            create_file asset unless File.exist?(asset)
            append_file asset, "\n#{ tech[:import] } #{ File.join(destination) }#{ tech[:postfix] }"
        end
    end

    def make_level_assets_path(level)
        BEM[:assets].each do |type, tech|
            create_file File.join level, level_assets_path, type.to_s, "level" + tech[:ext]
        end
    end

    def essence_exist?(essence_dir)
        File.directory? File.join BEM[:blocks][:path], essence_dir
    end

    def create_essence(essence_options, path)
        names = generate_names
        @css_class = '.' + names[:klass]
        # If you need more templates. Please create them into templates
        # directory. Watch existing templates for example.
        # What is .tt? It is custom extension for finding templates in other files.
        if options[:tech] # Maybe recive from command line
            template "#{ options[:tech] }.tt", File.join(BEM[:root], path, names[:name] + BEM[:techs][options[:tech].to_sym])
        else
            create_defaults(essence_options, path, names)
        end
    end

    def create_defaults(essence_options, path, names)
        BEM[:default].each do |tech|
            template "#{ tech }.tt", File.join(BEM[:root], path, names[:name] + BEM[:techs][tech])
        end
    end

    def remove_essence(essence_options, path)
        names = generate_names
        destination = File.join(essence_options[:dir], path)
        destination = File.join(destination, names[:name] + BEM[:techs][options[:tech].to_sym]) if options[:tech]
        remove_dir destination
    end

    def update_assets(name, path)
        level = BEM[:level]
        level ||= options[:level]
        BEM[:assets].each do |type, tech|
            asset = File.join(Rails.root, BEM[:root], level, level_assets_path, type.to_s, "level" + tech[:ext])
            # BEM[:root] > level > .bem > assets
            # 4 ../
            destination = ["../../../../", path, name + tech[:ext]].reject(&:empty?)
            create_file asset unless File.exist?(asset)
            append_file asset, "\n#{ tech[:import] } #{ File.join(destination) }#{ tech[:postfix] }"
        end
    end

    def cut_assets(name, path)
        level = BEM[:level]
        level ||= options[:level]
        BEM[:assets].each do |type, tech|
            asset = File.join(Rails.root, BEM[:root], level, level_assets_path, type.to_s, "level" + tech[:ext])
            destination = ["../../../../", path, name + tech[:ext]].reject(&:empty?)
            line = "#{ tech[:import] } #{ File.join(destination) }#{ tech[:postfix] }"

            tmp = Tempfile.new("temp")
            open(asset, 'r').each do |l|
                tmp << l unless l.chomp == line || l.empty?
            end
            tmp.close

            FileUtils.mv(tmp.path, asset)
        end
    end

    def search_usage_information(essence, path)
        BEM[:usage].each do |tech|
            file_destination = File.join(path_to_block(path), essence, essence + BEM[:techs][tech])
            read_usage(file_destination) if File.exist?(file_destination)
        end
    end

    def read_usage(target)
        puts "#{ tech }: #{ target }"
        puts "BEM[:usage]:\t"
        File.readlines(target) { |line| puts line }
    end

    def print_blocks_list(essence="", path)
        directory_destination = File.join(path_to_block(path), essence)
        parse_directory(:blocks, 'green', directory_destination)
    end

    def print_elements_list(ess_name="", path)
        directory_destination = File.join(path_to_block(path), ess_name, BEM[:elements][:dir])
        parse_directory(:elements, 'purple', directory_destination)
    end

    def print_mods_list(ess_name="", path)
        directory_destination = File.join(path_to_block(path), ess_name, BEM[:mods][:dir])
        parse_directory(:mods, 'cyan', directory_destination)
    end

    def print_values_list(ess_name="", path)
        directory_destination = File.join(path_to_block(path), ess_name)
        parse_directory(:mods, 'yellow', directory_destination)
    end

    def parse_directory(directory, essence, color)
        print_message("BEM[#{ essence }]:\t", color)
        Dir[directory + "/*"].each do |name|
            name = name.split('/')[-1]
            puts " - " + name.split(BEM[essence][:prefix])[1]
        end
    end

    def manipulate_essence(action, ess, path)
        ess_name = send(ess)
        ess_name = mod(options[:mod]) if ess == :mod
        destination = File.join(path, ess_name)

        case action
        when :create
            create_essence(BEM[ess.to_s.pluralize.to_sym], path)
            update_assets(ess_name, path)
        when :remove
            remove_essence(BEM[ess.to_s.pluralize.to_sym], path)
            cut_assets(ess_name, path)
        when :usage
            search_usage_information(ess_name, path) if essence_exist?(destination)
        else raise print_message("You should set params. Try 'thor help bem:#{ action }' for more information", 'red')
        end
    end
end
