module Evercookie #:nodoc
  module ControllerHelpers #:nodoc

    def evercookie_defined?(key, value)
      return true if Rails.env.test?


    end
  end

  class EvercookieController < ::ApplicationController

    def set
      @data = session[Evercookie.hash_name_for_set] || {key: '', value: ''}
    end

    def get
      @data = session[Evercookie.hash_name_for_get] || {key: '', value: ''}
    end

    def ec_png
      if not cookies[Evercookie.cookie_png].present?
        render :nothing => true, :status => 304
        return true
      end

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

      response.headers["Content-Type"] = "image/png"
      response.headers["Last-Modified"] = "Wed, 30 Jun 2010 21:36:48 GMT"
      response.headers["Expires"] = "Tue, 31 Dec 2030 23:30:45 GMT"
      response.headers["Cache-Control"] = "private, max-age=630720000"

      img_blob = image.to_blob(
          {color_mode: ChunkyPNG::COLOR_TRUECOLOR,
           compression: Zlib::DEFAULT_COMPRESSION}
      )

      render text: img_blob, status: 200, content_type: 'image/png'
    end

    def ec_etag
      if not cookies[Evercookie.cookie_etag].present?
        render :text => request.headers['If-None-Match'] || '', :status => 304
        return true
      end

      response.headers["Etag"] = cookies[Evercookie.cookie_etag]
      render text: cookies[Evercookie.cookie_etag]
    end

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
  end
end