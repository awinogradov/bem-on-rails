# Update list of known techs.
# BEM[:techs][:my_tech] = ".ext"

# List of default techs, generating if -T is empty.
# BEM[:default] << :my_tech

# Usage files variants. File for Readme about essences.
# BEM[:usage] << :my_tech

# Default directories, try to customize.
# Blocks directory in root of rails app.
# BEM[:blocks] = {
#   dir: "blocks",
#   path: Rails.root.join("blocks"),
#   prefix: "",
#   postfix: ""
# }
# Elements and mods directory in every block. Configure it's like blocks.
# Write 'dir: ""' for creating elements in root of block.
# BEM[:elements] = {
#   ...
# }
# BEM[:mods] = {
#   ...
# }

# [!] If you work with sass and you want to create blocks, elements and mods in sass,
# you should convert 'application.css' to 'application.css.sass'. Because, when
# blocks, elements or mods creates, technology files will be included to application
# files. This also applies to scss, styl, less and coffee. Customize this for use your
# favorite techs. Asset type may have postfix and it's optional.
# BEM[:assets] = {
#   stylesheets: {
#      ext: BEM[:techs][:scss],
#      import: '//= require',
#      posfix: ';'
#   },
#   javascripts: {
#      ...  
#   }
# }

# [!] Use CSSO instead of YUI.
# Watch here https://github.com/Vasfed/csso-rails