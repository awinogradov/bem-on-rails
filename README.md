[![Bem on Rails](http://habrastorage.org/storage3/551/97d/0c5/55197d0c503e312952195b2ae0e4c337.png)](https://github.com/verybigman/bem-on-rails)

# BEM on Rails

Work with BEM methodology in Rails applications. BEM on Rails is ruby copy from bem-tools. 
You can read about bem-tools [here](http://bem.info/tools/bem/) and BEM methodology [here](http://bem.info/method/).

## Installation

Add this line to your application's Gemfile:

    gem 'bem-on-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bem-on-rails
    
Then you should run install generator:

    $ rails g bemonrails:install

This generator adds lines to application_controller.rb, application_helper.rb and creates Thor task with templates.
You should run to watch your new instruments:
    
    $ thor -T 
    
Also generator creates initializer bem.rb with BEM constant. You should restart server after install. 
You can customize everythink!

## Usage

You can create blocks, elements, modificators and groups for blocks. It's awesome! Also you can remove them and watch
lists of blocks, block elements, blocks mods and etc. Try thor help for more info.

Default blocks folder structure:
 - **blocks**
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
   - **group_name**
     - **block_name**

You can specify all prefixes for blocks, elements and mods in bem.rb initializer.

### Creating

Easy block creating look like:

    $ thor bem:create -b test
    
Block with modificator:

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

Element in special tehcnology creates like block. List of know technologies you can see in bem.rb
initializer. You can customize it. After block, element or mod creating generator 
adds to assets main file (application) require string. Ex:
```sass
//= require test/elements/__field/__field.css.sass
```
You should remember! You are not in any case should not be writing styles and scripts in assets application files.
Use them like configs, for require only. This involves using Sprockets.

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

Syntax is look like [bemhtml](http://ru.bem.info/articles/bemhtml-reference/).

### Templates

Now templates exists for haml, sass, coffee and md technologies, but you will create your templates in
lib/tasks/templates. For example, you can watch haml template:
```haml
%div{ bemattrs }
	= bemcontent
```
Bemclass and bemcontent is BEM helpers for rendering. 

### You want more BEM?

You can use CSSO instead of YUI compressor for precompile assets. 
Read [here](http://habrahabr.ru/post/181880/) about it.

If you want it, please watch [here](https://github.com/Vasfed/csso-rails).

## Tomorrow

0. Incapsulate helpers methods and isolate them from project helpers.
1. Custom tag for block or element.
2. Flags bem and js.
3. Mix blocks and elements.
4. Mods with restructure. Now you can't use mods with templates(haml, slim and etc.), but they generates.
5. Bem exutable. Work with Thor is not convenient.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
