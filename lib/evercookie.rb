module Evercookie
  autoload :ViewHelper,        'evercookie/view'
  autoload :ControllerHelpers, 'evercookie/controller'
  autoload :EvercookieController, 'evercookie/controller'

  mattr_accessor :namespace
  @@namespace = :evercookie

  mattr_accessor :js_class
  @@js_class = :evercookie

  mattr_accessor :cookie_cache
  @@cookie_cache = :evercookie_cache

  mattr_accessor :cookie_etag
  @@cookie_etag = :evercookie_etag

  mattr_accessor :cookie_png
  @@cookie_png = :evercookie_png

  mattr_accessor :hash_name
  @@hash_name = :evercookie

  def self.setup
    yield self
  end

  def self.get_namespace
    @@namespace.to_sym
  end

  def self.hash_name_for_set
    "#{@@hash_name}_set".to_sym
  end

  def self.hash_name_for_get
    "#{@@hash_name}_get".to_sym
  end

  def self.hash_name_for_saved
    "#{@@hash_name}_saved".to_sym
  end

  def self.get_cookie_path
    "/#{get_namespace}/"
  end

  def self.get_save_path
    "/#{get_namespace}/save"
  end

  def self.get_cache_path
    "/#{get_namespace}/ec_cache"
  end

  def self.get_etag_path
    "/#{get_namespace}/ec_etag"
  end

  def self.get_png_path
    "/#{get_namespace}/ec_png"
  end
end

require 'evercookie/engine' if defined?(Rails)