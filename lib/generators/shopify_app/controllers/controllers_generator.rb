require 'rails/generators/base'

module ShopifyApp
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../..", __FILE__)

      def create_controllers
        controllers.each do |controller|
          copy_file controller
        end
      end

      def inject_current_shop_helper
        if host_has_shop_model?
          inject_into_file(
            "app/controllers/authenticated_controller.rb",
            current_shop_helper,
            after: "layout ShopifyApp.configuration.embedded_app? ? 'embedded_app' : 'application'"
          )
        end
      end

      private

      def controllers
        files_within_root('.', 'app/controllers/*.*')
      end

      def files_within_root(prefix, glob)
        root = "#{self.class.source_root}/#{prefix}"

        Dir["#{root}/#{glob}"].sort.map do |full_path|
          full_path.sub(root, '.').gsub('/./', '/')
        end
      end

      def host_has_shop_model?
        File.exist? "app/models/shop.rb"
      end

      def current_shop_helper
  "\n
  def current_shop
    return nil unless session[:shopify]
    @current_shop ||= Shop.find(session[:shopify])
  end\n"
      end

    end
  end
end
