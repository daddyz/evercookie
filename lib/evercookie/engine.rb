module Evercookie
  # adds additional things to rails engine
  module Rails
    # adds additional things to rails engine
    class Engine < ::Rails::Engine
      # adds ec.js to be precompiled
      initializer "evercookie precompile hook" do |app|
        app.config.assets.precompile += %w(ec.js)
      end

      # registers view helpers
      config.after_initialize do
        ActionView::Base.send(:include, Evercookie::ViewHelper)
      end
    end
  end
end