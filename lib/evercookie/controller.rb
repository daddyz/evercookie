module Evercookie
  # defines controller helpers
  module ControllerHelpers

    # Get value of evercookie by key
    # == Examples:
    #   evercookie_get_value(:key)
    #
    def evercookie_get_value(key)
      if session[Evercookie.hash_name_for_saved].present?
        session[Evercookie.hash_name_for_saved][key]
      else
        nil
      end
    end

    # Set evercookie value to session
    # == Examples:
    #   set_evercookie(:key, :value)
    #
    def set_evercookie(key, value)
      session[Evercookie.hash_name_for_saved] = {} unless
        session[Evercookie.hash_name_for_saved].present?
      session[Evercookie.hash_name_for_saved][key] = value
    end

    # Checks whether the evercookie with specific key was defined
    # == Examples:
    #   evercookie_is_set?(:key)
    #   evercookie_is_set?(:key, :value)
    #
    def evercookie_is_set?(key, value = nil)
      if session[Evercookie.hash_name_for_saved].blank?
        false
      elsif value.nil?
        session[Evercookie.hash_name_for_saved][key].present?
      else
        session[Evercookie.hash_name_for_saved][key].present? \
          && session[Evercookie.hash_name_for_saved][key] == value
      end
    end
  end

  # controller class defines evercookie actions
  class EvercookieController < ::ActionController::Base
    if Evercookie.rails5?
      protect_from_forgery except: [:set, :get, :save, :ec_png, :ec_etag, :ec_auth]
      before_action :basic_auth, only: [ :ec_auth ]
    else
      before_filter :basic_auth, only: [ :ec_auth ]
    end

    # Renders javascript with evercookie set script
    def set
      @data = session[Evercookie.hash_name_for_set] || {key: '', value: ''}
    end

    # Renders javascript with evercookie get script
    def get
      @data = session[Evercookie.hash_name_for_get] || {key: '', value: ''}
    end

    # Saves current evercookie value to session
    def save
      if data = session[Evercookie.hash_name_for_get]
        if data[:key] && cookies[data[:key]]
          session[Evercookie.hash_name_for_saved] =
              { data[:key] => cookies[data[:key]] }
        end
      end
      render_nothing
    end

    # Renders png image with encoded evercookie value in it
    def ec_png
      if not cookies[Evercookie.cookie_png].present?
        render_nothing :not_modified
        return true
      end

      response.headers["Content-Type"] = "image/png"
      response.headers["Last-Modified"] = "Wed, 30 Jun 2010 21:36:48 GMT"
      response.headers["Expires"] = "Tue, 31 Dec 2030 23:30:45 GMT"
      response.headers["Cache-Control"] = "private, max-age=630720000"

      key = Evercookie.rails5? ? :body : :text
      render key => get_blob_png, :status => 200, :content_type => 'image/png'
    end

    # Renders page with etag header for evercookie js script
    def ec_etag
      if not cookies[Evercookie.cookie_etag].present?
        render Evercookie.plain_key => request.headers['If-None-Match'] || '', :status => 304
        return true
      end

      puts "cache value (#{Evercookie.cookie_etag}): #{cookies[Evercookie.cookie_etag]}"

      response.headers["Etag"] = cookies[Evercookie.cookie_etag]
      render Evercookie.plain_key => cookies[Evercookie.cookie_etag]
    end

    # Renders page with cache header for evercookie js script
    def ec_cache
      if not cookies[Evercookie.cookie_cache].present?
        render_nothing :not_modified
        return true
      end

      puts "cache value (#{Evercookie.cookie_cache}): #{cookies[Evercookie.cookie_cache]}"

      response.headers["Content-Type"] = "text/html"
      response.headers["Last-Modified"] = "Wed, 30 Jun 2010 21:36:48 GMT"
      response.headers["Expires"] = "Tue, 31 Dec 2030 23:30:45 GMT"
      response.headers["Cache-Control"] = "private, max-age=630720000"

      render Evercookie.plain_key => cookies[Evercookie.cookie_cache]
    end

    # Renders evercookie value for basic authentication if it was set
    def ec_auth
      render Evercookie.plain_key => @username
    end

    private

    def render_nothing(status = :ok)
      if Evercookie.rails5?
        head status
      else
        render nothing: true, status: status
      end
    end

    def basic_auth
      authenticate_with_http_basic do |username, password|
        @username = username
        true
      end
    end

    def get_blob_png
      value = cookies[Evercookie.cookie_png]
      puts "png value (#{Evercookie.cookie_png}): #{value}"
      require 'chunky_png'
      image = ChunkyPNG::Image.new(200, 1, ChunkyPNG::Color::BLACK)

      (0..value.length).step(3) do |index|
        image[(index / 3).round, 0] = get_pixel_by_index(value, index)
      end

      image.to_blob(
          {color_mode: ChunkyPNG::COLOR_TRUECOLOR,
          compression: Zlib::DEFAULT_COMPRESSION}
      )
    end

    def get_pixel_by_index(value, index)
      red = value[index] ? value[index].ord : 0
      green = value[index + 1] ? value[index + 1].ord : 0
      blue = value[index + 2] ? value[index + 2].ord : 0

      ChunkyPNG::Color.rgb(red, green, blue)
    end
  end
end
