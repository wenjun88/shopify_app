module ShopifyApp
  class Engine < Rails::Engine
    engine_name 'shopify_app'
    isolate_namespace ShopifyApp

    initializer "shopify_app.assets.precompile" do |app|
      app.config.assets.precompile += %w[
        shopify_app/redirect.js
        shopify_app/itp_polyfill.js
        shopify_app/storage_access.js
        shopify_app/utilities/user_agent.js
      ]
    end
  end
end
