# BEM on Rails

This README also available in [russian](https://github.com/verybigman/bem-on-rails/blob/master/README.ru.md).

Work with BEM methodology in Rails applications. BEM on Rails is ruby fork of bem-tools. You can read about bem-tools [here](http://bem.info/tools/bem/) and BEM methodology [here](http://bem.info/method/). Also i talk about this gem in russian on YaC 2013, you can watch this [here](http://tech.yandex.ru/events/bemup/yac-bemup/talks/1349/).

## Installation

Add this line to your application's Gemfile:

    gem 'bem-on-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bem-on-rails

Then you should run install generator:

    $ rails g bemonrails:install

You should restart server after install.
You can customize everythink in initializers/bem.rb!

## Usage

You can create blocks, elements, modificators and levels. Default folder structure:

- **bem**
    - **level_name**
        - **block_name**
            - **__element_name**
                - block-name__element_name.html.haml
                - block-name__element_name.css.sass
                - block-name__element_name.coffee
                - block-name__element_name.md
            - **_mod_name**
                - block-name_mod_name.css.sass
                - block-name_mod_name.coffee
                - block-name_mod_name.md
            - block_name.html.haml
            - block_name.css.sass
            - block_name.coffee
            - block_name.md

You can read more about folders structure [here](http://bem.info/method/filesystem/). Also specify all prefixes for blocks, elements and mods in bem.rb initializer.

### Creating

Easy block creating look like:

    $ thor bem:create -l level-name -b test

Block with mod:

    $ thor bem:create -l level-name -b test -m large

Block with pretty mod with value:

    $ thor bem:create -l level-name -b test -m color -v red

Create element:

    $ thor bem:create -l level-name -b test -e icon

Element with mod:

    $ thor bem:create -l level-name -b test -e icon -m large

Element with pretty mod:

    $ thor bem:create -l level-name -b test -e icon -m size -v small

Block in special technolody:
    $ thor bem:create -l level-name -b test -T sass

Element in special tehcnology creates like block. List of know technologies you can see in bem.rb initializer. You can customize it. After block, element or mod creating generator adds to level assets (level_name/.bem/assets) main file (level) require string. Ex:
```sass
//= require ../../../../test/__field/test__field.css.sass
```
You should remember! You are not in any case should not be writing styles and scripts in assets levels and application files.
Use them like configuration files, for require only. This involves using Sprockets.

### Rendering

In your view you should write this:
```ruby
= block "test", mods: [{color: "red"}], content: [{ elem: "icon", elemMods: [{size: "small"}] }]

= block "test", mods: [:super, {color: "red"}], content: []

= block "test", attrs: {src: "/img.png"}, content: []

= block "test", cls: "custom", content: []

= b "test", tag: "article", content: []
```

Syntax is look like original [BEMJSON](http://ru.bem.info/technology/bemjson/v2/bemjson/).

### Templates

Now templates exists for haml, sass, coffee and md technologies, but you will create your templates in lib/tasks/templates. For example, you can watch haml template:
```haml
- haml_tag this[:tag], this[:attrs]
    = content
```
Or Slim template:
```slim
* this[:tag], this[:attrs]
    = content
```
`this` and `content` is BEM helpers for rendering. `this` is access to default essence propeties, `content` is access to context properties.

### You want more BEM?

More information you can find on [official site of BEM](http://bem.info)

### Authors
 
- Anton Winogradov ([verybigman](https://github.com/verybigman)) @awinogradov
 
### Ideas
 
Please, talk about your ideas by GitHub [issues](https://github.com/verybigman/bem-on-rails/issues).
 
### [MIT](http://en.wikipedia.org/wiki/MIT_License) License
