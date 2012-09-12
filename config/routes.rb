Rails.application.routes.draw do

  # Adds routes for evercookie under namespace (path)
  scope "#{Evercookie.get_namespace}" do
    # route for js file to set cookie
    match 'set' => "evercookie/evercookie#set", as: :evercookie_set
    # route for js file to get cookie
    match 'get' => "evercookie/evercookie#get", as: :evercookie_get
    # route for save action to save cookie value to session
    match 'save' => "evercookie/evercookie#save", as: :evercookie_save

    # route to png image to be tracked by js script
    match 'ec_png' => "evercookie/evercookie#ec_png", as: :evercookie_png
    # route to etag action to be tracked by js script
    match 'ec_etag' => "evercookie/evercookie#ec_etag", as: :evercookie_etag
    # route to cache action to be tracked by js script
    match 'ec_cache' => "evercookie/evercookie#ec_cache", as: :evercookie_cache
  end

end