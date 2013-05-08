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
      if value.nil?
        session[Evercookie.hash_name_for_saved][key].present?
      else
        session[Evercookie.hash_name_for_saved][key].present? \
          && session[Evercookie.hash_name_for_saved][key] == value
      end
    end
  end

  # controller class defines evercookie actions
  class EvercookieController < ::ApplicationController

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
      render nothing: true
    end

    # Renders png image with encoded evercookie value in it
    def ec_png
      if not cookies[Evercookie.cookie_png].present?
        render :nothing => true, :status => 304
        return true
      end

      response.headers["Content-Type"] = "image/png"
      response.headers["Last-Modified"] = "Wed, 30 Jun 2010 21:36:48 GMT"
      response.headers["Expires"] = "Tue, 31 Dec 2030 23:30:45 GMT"
      response.headers["Cache-Control"] = "private, max-age=630720000"

      render text: get_blob_png, status: 200, content_type: 'image/png'
    end

    # Renders page with etag header for evercookie js script
    def ec_etag
      if not cookies[Evercookie.cookie_etag].present?
        render :text => request.headers['If-None-Match'] || '', :status => 304
        return true
      end

      response.headers["Etag"] = cookies[Evercookie.cookie_etag]
      render text: cookies[Evercookie.cookie_etag]
    end

    # Renders page with cache header for evercookie js script
    def ec_cache
      if not cookies[Evercookie.cookie_cache].present?
        render :nothing => true, :status => 304
        return true
      end

      response.headers["Content-Type"] = "text/html"
      response.headers["Last-Modified"] = "Wed, 30 Jun 2010 21:36:48 GMT"
      response.headers["Expires"] = "Tue, 31 Dec 2030 23:30:45 GMT"
      response.headers["Cache-Control"] = "private, max-age=630720000"

      render text: cookies[Evercookie.cookie_cache]
    end

    private
    def get_blob_png
      value = cookies[Evercookie.cookie_png]

      require 'chunky_png'
      image = ChunkyPNG::Image.new(200, 1, ChunkyPNG::Color::BLACK)

      pixel = 0
      while (index = pixel * 3) < value.length
        red = value[index] ? value[index].ord : 0
        green = value[index + 1] ? value[index + 1].ord : 0
        blue = value[index + 2] ? value[index + 2].ord : 0

        image[pixel, 0] = ChunkyPNG::Color.rgb(red, green, blue)

        pixel += 1
      end

      image.to_blob(
          {color_mode: ChunkyPNG::COLOR_TRUECOLOR,
          compression: Zlib::DEFAULT_COMPRESSION}
      )
    end
  end
end
