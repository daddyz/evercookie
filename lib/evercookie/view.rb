module Evercookie
  # module defines view helpers
  module ViewHelper

    # Generates javascript for setting evercookie
    # == Example:
    #   <%= set_evercookie(:key, :value) %>
    def set_evercookie(key, value)
      session[Evercookie.hash_name_for_set] = {key: key, value: value}
      render inline: "<%= javascript_include_tag 'ec', evercookie_set_path -%>"
    end

    # Generates javascript for checking if evercookie exists and getting it's
    # value
    # == Example:
    #   <%= check_evercookie(:key) %>
    def check_evercookie(key)
      if not session[Evercookie.hash_name_for_get].present?
        session[Evercookie.hash_name_for_get] = {}
      end
      session[Evercookie.hash_name_for_get][:key] = key
      render inline: "<%= javascript_include_tag 'ec', evercookie_get_path -%>"
    end
  end
end