BEM = {}

BEM[:root] = "bem"
BEM[:attrs] = [:block, :elem, :mods, :elemMods, :bem, :js, :jsAttr, :cls, :tag, :mix, :content, :attrs]

BEM[:app] = Rails.application.class.to_s.split("::").first.underscore.split('_').map(&:downcase).join('-')

# Default levels
BEM[:levels] = []
BEM[:levels].push({ name: BEM[:app] }) # levels stack
BEM[:level] = BEM[:app] # default level

# List of known techs.
BEM[:techs] = {
    haml: ".html.haml",
    slim: ".html.slim",
    erb: "html.erb",
    jade: ".jade",
    sass: ".css.sass",
    scss: ".css.scss",
    less: ".css.less",
    styl: ".css.styl",
    css: ".css",
    coffee: ".coffee",
    js: ".js",
    md: ".md",
    wiki: ".wiki"
}

# List of default techs, generating if -T is empty.
BEM[:default] = [:haml, :sass, :coffee, :md]

# Default directories, try to customize.
# Blocks directory in root of rails app.
BEM[:blocks] = {
    dir: BEM[:root],
    prefix: "",
    postfix: ""
}

# Elements directory in every block directory.
# Write 'dir: ""' for creating elements in root of block.
BEM[:elements] = {
    dir: '',
    prefix: '__',
    postfix: ''
}

# Mods directory in every block directory.
# Write 'dir: ""' for creating mods in root of block.
BEM[:mods] = {
    dir: '',
    prefix: '_',
    postfix: '_'
}

# [!] If you work with sass and you want to create blocks, elements and mods in sass,
# you should convert 'application.css' to 'application.css.sass'. Because, when
# blocks, elements or mods is created, technology files will be included to application
# files. This also applies to scss, styl, less and coffee. Customize this for use your
# favorite techs. Asset type may have postfix and it's optional.
# Example:
#
# assets = {
#   stylesheets:
#       {
#           ext: BEM[:techs][:scss],
#           import: '//= require',
#           posfix: ';'
#       }
# }
BEM[:assets] = {
    stylesheets:
    {
        ext: BEM[:techs][:sass],
        import: '//= require'
    },
    javascripts:
    {
        ext: BEM[:techs][:js],
        import: '//= require'
    }
}

# You must use application files in
# assets as a configs, don't write code in them.
# This is need to sprokets includes.
Rails.application.config.assets.paths << BEM[:root]
