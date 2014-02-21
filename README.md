[![Bem on Rails](http://habrastorage.org/storage3/551/97d/0c5/55197d0c503e312952195b2ae0e4c337.png)](https://github.com/verybigman/bem-on-rails)

# BEM on Rails

Work with BEM methodology in Rails applications. BEM on Rails is ruby copy from bem-tools. 
You can read about bem-tools [here](http://bem.info/tools/bem/) and BEM methodology [here](http://bem.info/method/). Also i talk about this gem in russian on YAC 2013, watch this [here](http://tech.yandex.ru/events/bemup/yac-bemup/talks/1349/).

## Installation

Add this line to your application's Gemfile:

    gem 'bem-on-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bem-on-rails
    
Then you should run install generator:

    $ rails g bemonrails:install

This generator creates Thor task with templates. You should run to watch your new instruments:
    
    $ thor -T 

If you want use default level, you must be create folders tree for it:

    $ thor bem:levels -a --default
    
You should restart server after install. 
You can customize everythink in initializers/bem.rb!

## Usage

You can create blocks, elements, modificators and groups for blocks. It's awesome! Also you can remove them and watch lists of blocks, block elements, blocks mods and etc. Try thor help for more info.

Default blocks folder structure:

- **bem**
    - **level_name**
        - **block_name**
            - **elements**
                - **__element_name**
                    - __element_name.html.haml
                    - __element_name.css.sass
                    - __element_name.coffee
                    - __element_name.md
            - **mods**
                - **_mod_name**
                    - **_mod_value**
                    - _mod_name.css.sass
                    - _mod_name.coffee
                    - _mod_name.md
            - block_name.html.haml
            - block_name.css.sass
            - block_name.coffee
            - block_name.md

You can specify all prefixes for blocks, elements and mods in bem.rb initializer.

**All blocks now creates on levels.**

### Levels

Create new level:

    $ thor bem:levels -a -n level_name
    
Get from git:

    $ thor bem:levels -a -g git@github.com:verybigman/bem-controls.git
    
Copy from directory:

    $ thor bem:levels -a -d ~/path/to/level_name

### Creating

Easy block creating look like:

    $ thor bem:create -b test
    
Block with mod:

    $ thor bem:create -b test -m large

Block with pretty mod with value:
    
    $ thor bem:create -b test -m color -v red

Create element:

    $ thor bem:create -b test -e icon
    
Element with mod:

    $ thor bem:create -b test -e icon -m large
    
Element with pretty mod:

    $ thor bem:create -b test -e icon -m size -v small

Block in special technolody:
    $ thor bem:create -b test -T sass

Element in special tehcnology creates like block. List of know technologies you can see in bem.rb initializer. You can customize it. After block, element or mod creating generator adds to level assets (level_name/.bem/assets) main file (level) require string. Ex:
```sass
//= require ../../../../test/elements/__field/__field.css.sass
```
You should remember! You are not in any case should not be writing styles and scripts in assets levels and application files.
Use them like configuration files, for require only. This involves using Sprockets.

### Rendering

In your view you should write this:
```ruby
= b "test", mods: [{color: "red"}], content: [{ elem: "icon", elemMods: [{size: "small"}] }]
```

If block in group:
```ruby
= b "test", group: "name", mods: [{color: "red"}], content: []
```

Block with mods without value:
```ruby
= b "test", mods: [:super, {color: "red"}], content: []
```

Block with custom attributes for tag:
```ruby
= b "test", attrs: {src: "/img.png"}, content: []
```

Block with custom class for tag:
```ruby
= b "test", cls: "custom", content: []
```

Block with custom tag for block( 'div' is default ):
```ruby
= b "test", tag: "article", content: []
```

Syntax is look like [bemhtml](http://ru.bem.info/articles/bemhtml-reference/).

### Templates

Now templates exists for haml, sass, coffee and md technologies, but you will create your templates in
lib/tasks/templates. For example, you can watch haml template:
```haml
- haml_tag this[:tag], this[:attrs]
    = content
```
Or Slim template:
```slim
* this[:tag], this[:attrs]
    = content
```
This and content is BEM helpers for rendering. For access to default essence propeties use 'this' method.
For access to custom essence properties use 'ctx' method.

### You want more BEM?

You can use CSSO instead of YUI compressor for precompile assets. 
Read [here](http://habrahabr.ru/post/181880/) about it.

If you want it, please watch [here](https://github.com/Vasfed/csso-rails).

#### Think better. Stay BEMed!
