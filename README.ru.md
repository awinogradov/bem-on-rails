# BEM on Rails

Позволяет использовать БЭМ методологию в Rails приложениях. BEM on Rails это Ruby форк частичного функционала bem-tools. Узнать, что такое bem-tools можно здесь [здесь](http://bem.info/tools/bem/), а о самой БЭМ методологии [здесь](http://bem.info/method/). Кроме того, я выступал с докладом об этом геме на YaC 2013, который можно найти [здесь](http://tech.yandex.ru/events/bemup/yac-bemup/talks/1349/).

## Установка

Добавьте эту строку в Gemfile:

    gem 'bem-on-rails'

Затем запустите бандлер:

    $ bundle
    
Далее запускаем генератор:

    $ rails g bemonrails:install
    
Если сервер запущен, его надо бы перезапустить. 

## Использование

Вы можете создавать блоки, элементы и их модификаторы на разных уровнях. Так выглядит стандартная структура директорий:

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

Больше информации об организации файловой системы можно найти [здесь](http://bem.info/method/filesystem/).

### Создание новых блоков

Простой пример:

    $ thor bem:create -l level-name -b test
    
Блок с булевым модификатором:

    $ thor bem:create -l level-name -b test -m large

Блок с модификатором и его значением:
    
    $ thor bem:create -l level-name -b test -m color -v red

Создание элемента:

    $ thor bem:create -l level-name -b test -e icon

Создание сущности в необходимой технологии:

    $ thor bem:create -l level-name -b test -T sass

Список используюмых технологий находится в bem.rb initializer. Во время создания сущностей создаются записи в файлах ассетов (level_name/.bem/assets). Например:
```sass
//= require ../../../../test/__field/test__field.css.sass
```
Пожалуйста, не пишите ничего самостоятельно в этих файлах.

### Вьюхи

Haml:
```ruby
= block "test", mods: [{color: "red"}], content: [{ elem: "icon", elemMods: [{size: "small"}] }]

= block "test", mods: [:super, {color: "red"}], content: []

= block "test", attrs: {src: "/img.png"}, content: []

= block "test", cls: "custom", content: []

= block "test", tag: "article", content: []
```

Синтаксис схож с ориганльным из [BEMJSON](http://ru.bem.info/technology/bemjson/v2/bemjson/).

### Шаблоны

По умолчанию шаблоны можно писать на haml, sass, coffee и md, но вы можете создать свои технологии, какие вам только будут необходимы по примеру со стандартными из lib/tasks/templates. Например так выглядит шаблон для haml:
```haml
- haml_tag this[:tag], this[:attrs]
    = content
```
А вот так для Slim:
```slim
* this[:tag], this[:attrs]
    = content
```
`this` и `content` это БЭМ помощники для рендеринга. `this` используется для доступа к стандартным полям сущности, а 'ctx' для доступа к полям контекста.

### Хотите больше информации о БЭМ?

Много полезных статей на [официальном БЭМ сайте](http://bem.info)

### Авторы

- Антон Виноградов ([verybigman](https://github.com/verybigman)) @awinogradov

### Идеи, замечания и пожелания

Все это можно оформить в виде [issues](https://github.com/verybigman/bem-on-rails/issues) на GitHub.

### [MIT](http://en.wikipedia.org/wiki/MIT_License) Лицензия
