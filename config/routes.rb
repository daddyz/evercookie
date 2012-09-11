Rails.application.routes.draw do

  scope "#{Evercookie.get_namespace}" do
    match 'set' => "evercookie/evercookie#set", as: :evercookie_set
    match 'get' => "evercookie/evercookie#get", as: :evercookie_get
    match 'save' => "evercookie/evercookie#save", as: :evercookie_save

    match 'ec_png' => "evercookie/evercookie#ec_png", as: :evercookie_png
    match 'ec_etag' => "evercookie/evercookie#ec_etag", as: :evercookie_etag
    match 'ec_cache' => "evercookie/evercookie#ec_cache", as: :evercookie_cache
  end

end