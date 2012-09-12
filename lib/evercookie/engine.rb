module Evercookie
  module Rails
    class Engine < ::Rails::Engine
      initializer "evercookie precompile hook" do |app|
        app.config.assets.precompile += %w(ec.js)
      end

      config.after_initialize do
        ActionView::Base.send(:include, Evercookie::ViewHelper)
      end
    end
  end
end