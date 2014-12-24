require File.expand_path('config/environment.rb')

class Bem < Thor
    include Thor::Actions
    include Bemonrails::BemNames
    include Bemonrails::ConsoleMessages

    source_root File.expand_path('../templates', __FILE__)

    LEVEL_ASSETS = File.join ".bem", "assets"

    desc 'create', 'Create block, element or mod'
    method_option :block, type: :string, aliases: "-b", desc: "Create block in default techs."
    method_option :element, type: :string, aliases: "-e", desc: "Create element in default techs."
    method_option :mod, type: :string, aliases: "-m", desc: "Create modificator for block or element."
    method_option :value, type: :string, aliases: "-v", desc: "Value for modificator."
    method_option :tech, type: :string, aliases: "-T", desc: "Create essence in spec tech."
    method_option :level, type: :string, aliases: "-l", desc: "Create essence in level."
    def create
        create_level unless level_exist?

        ess = resolve_essence
        path = path_resolve(ess)
        name = build_def(ess)
        dest = File.join path, name

        create_essence(BEM[ess.to_s.pluralize.to_sym], path)

        update_assets(name, path)
    end

    protected

    def level_exist?(l=options[:level])
        File.directory? Rails.root.join BEM[:root], l
    end

    def create_level(l=options[:level])
        target = Rails.root.join BEM[:root], l

        # Make files for level assets
        BEM[:assets].each do |type, tech|
            create_file File.join target, LEVEL_ASSETS, type.to_s, "level" + tech[:ext]
        end

        # Update app assets with levels assets
        BEM[:assets].each do |type, tech|
            asset = File.join(Rails.root, "app", "assets", type.to_s, "application" + tech[:ext])
            destination = [l, LEVEL_ASSETS, type.to_s, "level" + tech[:ext]]
            create_file asset unless File.exist?(asset)
            append_file asset, "\n#{ tech[:import] } #{ File.join(destination) }#{ tech[:postfix] }"
        end
    end

    def create_essence(essence_options, path)
        names = generate_klass
        @css_class = '.' + names[:klass]
        # If you need more templates. Please create them into templates
        # directory. Watch existing templates for example.
        # What is .tt? It is custom extension for finding templates in other files.
        if options[:tech] # Maybe recive from command line
            template "#{ options[:tech] }.tt", File.join(BEM[:root], path, names[:klass] + BEM[:techs][options[:tech].to_sym])
        else
            defaults(essence_options, path, names)
        end
    end

    def defaults(essence_options, path, names)
        BEM[:default].each do |tech|
            template "#{ tech }.tt", File.join(BEM[:root], path, names[:klass] + BEM[:techs][tech])
        end
    end

    def update_assets(name, path)
        level = BEM[:level] || options[:level]

        BEM[:assets].each do |type, tech|
            asset = File.join(Rails.root, BEM[:root], level, LEVEL_ASSETS, type.to_s, "level" + tech[:ext])
            # BEM[:root] > level > .bem > assets
            # 4 ../
            destination = ["../../../../", path, name + tech[:ext]].reject(&:empty?)
            create_file asset unless File.exist?(asset)
            append_file asset, "\n#{ tech[:import] } #{ File.join(destination) }#{ tech[:postfix] }"
        end
    end

end
