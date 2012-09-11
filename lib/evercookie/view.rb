module Evercookie #:nodoc
  module ViewHelper #:nodoc

    def set_evercookie(key, value)
      session[Evercookie.hash_name_for_set] = {key: key, value: value}
      render inline: "<%= javascript_include_tag 'ec', evercookie_set_path -%>"
    end

    def check_evercookie(key)
      if not session[Evercookie.hash_name_for_get].present?
        session[Evercookie.hash_name_for_get] = {}
      end
      session[Evercookie.hash_name_for_get][:key] = key
      render inline: "<%= javascript_include_tag 'ec', evercookie_get_path -%>"
    end
  end
end