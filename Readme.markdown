**Crystalmeta helps you control meta tags through I18n and/or manually. It plays well with [OpenGraph](http://ogp.me/).**

It gives you 3 helpers:

**1.** `meta(options)` — available in both controller & views.

Accepts `Hash`.

Collects meta tags for future use:

```ruby
# folded hashes
meta og: {title: "The Rock (1996)", type: "video.movie"}

# one level hash
meta "og:title" => "The Rock (1996)", "og:type" => "video.movie"
meta :"og:image" => "the-rock.png"
```

**2.** `meta_tag(name)` — available in views

Accepts `String` or `Symbol`.

Returns value for a certain tag:

```erb
<title><%= meta_tag 'og:title' %></title>
```

**3.** `meta_tags(pattern = //)`

Returns all meta tags which names match the pattern. Under the hoods it uses the three-qual to pattern match (like in `Enumerable#grep`).

```erb
<%= meta_tags %>
```

displays in this case:

```html
<meta property="og:url" content="http://www.imdb.com/title/tt0117500/" />
<meta property="og:image" content="/assets/the-rock.png" />
<meta property="og:title" content="The Rock (1996)" />
<meta property="og:type" content="video.movie" />
```

Please note that: 

* `image_path` is automatically used for `og:image` or `og:image:url` (`video_path` for `og:video` and `audio_path` for `og:audio` respectively), so you don't have to bother setting explicit paths;
* `og:url` is set to `controller.request.url`.

## I18n translations

Crystalmeta tries to fetch translations and merge them in this order (consider an example for `pages#show` action):

* `meta._defaults` — application defaults (lowest-priority)
* `meta.pages._defaults` — controller defaults
* `meta.pages.show` — action

Tags set manually by the `meta` helper will be given the highest priority.

**Namespaced controllers**

Crystalmeta uses `controller_path` in order to get the translation scope, so if you have a namespaced controller, for instance `Library::BooksController`, then the `show` action will use: `meta.library.books._defaults` & `meta.library.books.show` respectively.

**Aliases**

Crystalmeta uses translations for the `edit` action for `update`:

* `meta._defaults`
* `meta.movies._defaults`
* `meta.movies.edit`
* `meta.movies.update`

And `new` for `create`:

* `meta._defaults`
* `meta.movies._defaults`
* `meta.movies.new`
* `meta.movies.create`

You can omit defining translations for `update` & `create` actions if they're the same.

## Displaying only certain meta tags using a pattern

Usually I set window title with Crystalmeta separately (I call it `head` for example) and I don't want to display it in meta tags, so I can do:

```erb
<%= meta_tags /:/ %>
```

It will filter tag names using `/:/ === name`.

You may wish to use a `Proc` in some cases:

```erb
<%= meta_tags Proc.new{|name| name != "head"} %>
```

## Interpolation

You can interpolate meta tags like this:

```erb
<% meta({
  "og:title"     => "The Rock (1996)",
  "og:site_name" => "IMDb",
  "head"         => "%{og:title} — %{og:site_name}"
}) %>
```

`meta_tag :head` will return `"The Rock (1996) — IMDb"`.

Please use this feature with care to avoid [SystemStackError](http://ruby-doc.org/core-1.9.3/SystemStackError.html).

## Caveats

**Merging tags**

When tags are merged (while fetching translations or collecting with `meta`) Crystalmeta doesn't do anything smart — it just merges hashes brutally. So if you defined a tag like that:

```yml
en:
  meta:
    _defaults:
      og:
        title: IMDb
```

and then you redefine it in different style:

```ruby
meta 'og:title' => 'The Rock (1996)'
```

then you'll just get 2 tags in the end:

```erb
<%= meta_tags /og:title/ %>
```

will display

```html
<meta property="og:title" content="IMDb" />
<meta property="og:title" content="Newer IMDb" />
```

So you'd better prefer one style.

**Date/Time**

Crystalmeta will convert Date/Time/Datetime objects to [iso8601](http://en.wikipedia.org/wiki/ISO_8601) automatically, so if you don't want it, pass them as strings.

**Arrays**

To maximize [OpenGraph](http://ogp.me/#array) compatibility, Crystalmeta handles Arrays in similar way:

```erb
<% meta :og => {:image => %w{1.png 2.png}} %>
<%= meta_tags /og:image/ %>
```

will display:

```html
<meta property="og:image" content="/assets/1.png" />
<meta property="og:image" content="/assets/2.png" />
```

**Multiple images with properties**

If you have multiple images with properties like this:

```html
<meta property="og:image:url" content="/assets/rock.jpg" />
<meta property="og:image:width" content="300" />
<meta property="og:image:height" content="300" />
<meta property="og:image:url" content="/assets/rock2.jpg" />
<meta property="og:image:url" content="/assets/rock3.jpg" />
<meta property="og:image:height" content="1000" />
```

then you'll have to set them in a special way:

```erb
<% meta 'og:image' => [
  {:url => 'rock.jpg', :width => 300, :height => 300},
  {:url => 'rock2.jpg'},
  {:url => 'rock3.jpg', :height => 1000},
] %>
```

or:

```yml
en:
  meta:
    pages:
      show:
        og:image:
          - url: rock.jpg
            width: 300
            height: 300
          - url: rock2.jpg
          - url: rock3.jpg
            height: 1000
```

It will sort keys so that the `url` property is on top.
