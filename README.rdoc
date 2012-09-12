## Evercookie

Evercookie is a gem allowing you to use very persistent cookies on your rails project to track existing users on your system.
It's javascript is based on https://github.com/samyk/evercookie javascript.
Please note, that evercookie can't be fully reliable for detecting previous visiting of your site/application. For people who know the job it's simple enough to override it.

As written on original javascript site (http://samy.pl/evercookie/), when creating a new cookie, it uses the following storage mechanisms when available:
* Standard [HTTP Cookies](http://en.wikipedia.org/wiki/HTTP_cookie)
* [Local Shared Objects](http://en.wikipedia.org/wiki/Local_Shared_Object) (Flash Cookies)
* [Isolated Storage](http://www.silverlight.net/learn/quickstarts/isolatedstorage/) Silverlight (removed in gem)
* Storing cookies in RGB values of auto-generated, force-cached PNGs using HTML5 Canvas tag to read pixels (cookies) back out
* Storing cookies in and reading out [Web History](http://samy.pl/csshack/) (removed in gem)
* Storing cookies in HTTP [ETags](http://en.wikipedia.org/wiki/HTTP_ETag)
* Storing cookies in [Web cache](http://en.wikipedia.org/wiki/Web_cache)
* [window.name](http://en.wikipedia.org/wiki/HTTP_cookie#window.name) caching
* Internet Explorer [userData](http://msdn.microsoft.com/en-us/library/ms531424(VS.85).aspx) storage
* HTML5 [Session Storage](http://dev.w3.org/html5/webstorage/#the-sessionstorage-attribute)
* HTML5 [Local Storage](http://dev.w3.org/html5/webstorage/#dom-localstorage)
* HTML5 [Global Storage](https://developer.mozilla.org/en/dom/storage#globalStorage)
* HTML5 [Database Storage](http://dev.w3.org/html5/webdatabase) via SQLite

## Information

### Bug reports

If you discover a problem with Evercookie gem, let us know about it.
https://github.com/daddyz/evercookie/issues

### Example application

You can see an example of evercookie working in test/dummy application of this gem

## Getting started

Evercookie works was written and tested on Rails 3.2. You can add in to your Gemfile with:

```ruby
gem 'evercookie'
```

Run the bundle command to install it.

### View helpers

View helper that adds javascript for setting the evercookie for client:

```ruby
set_evercookie(:key, :value)
```

View helper that checks whether the cookie was set on client side and resets if some of cookies were deleted:

```ruby
check_evercookie(:key)
```

### Controller helpers

Controller helper that gets the value of evercookie by key:

```ruby
evercookie_get_value(:key)
```

Controller helper that checks if specific evercookie was set:

```ruby
evercookie_is_set?(:key)
evercookie_is_set?(:key, :value)
```

### How it works

When you are calling:
* `set_evercookie` helper it adds javascript to set evercookie values in all available storage mechanisms.
* `check_evercookie` helper it adds javascript to get evercookie values from all storage mechanisms where it possible and resets their values where it was removed (like if user removed individual cookies it sets them back) and after that it calls it's controller action to save evercookie value in rails session
* `evercookie_get_value` helper in controller it checks evercookie's session for provided 'key' value and returns it if exists
* `evercookie_is_set?` helper in controller it checks if there is a provided 'key' in evercookie's session

### How this gem should be used

The main idea of this gem is to set somewhere in application an evercookie to track that this client already visited your application.
I used it to track multiple registrations in such scenario:
* After user was registered he was passed to specific view where I called set_evercookie helper:
```ruby
set_evercookie(:uid, user_unique_id)
```
* In user sign up page view I called check_evercookie helper:
```ruby
check_evercookie(:uid)
```
* In controller that was handling new user creation process I was running evercookie_get_value helper to check if previously I got evercookie value from user, and if I got it I was showing an error:
```ruby
evercookie_get_value(:uid)
```

### Configuring the gem

You can create the initializer for evercookie gem in your Rails application initializers folder:

```ruby
Evercookie.setup do |config|
  # path for evercookie controller
  config.namespace = :evercookie

  # name of javascript class to be used for evercookie
  config.js_class = :evercookie

  # hash name base for session storage variables
  config.hash_name = :evercookie

  # cookie name for cache storage
  config.cookie_cache = :evercookie_cache

  # cookie name for png storage
  config.cookie_png = :evercookie_png

  # cookie name for etag storage
  config.cookie_etag = :evercookie_etag
end
```

