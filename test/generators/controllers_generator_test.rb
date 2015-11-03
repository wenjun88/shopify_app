require 'test_helper'
require 'generators/shopify_app/controllers/controllers_generator'

class ControllersGeneratorTest < Rails::Generators::TestCase
  tests ShopifyApp::Generators::ControllersGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  test "copies ShopifyApp controllers to the host application" do
    run_generator
    assert_directory "app/controllers"
    assert_file "app/controllers/sessions_controller.rb"
    assert_file "app/controllers/authenticated_controller.rb"
  end

  test "doesn't add current_shop helper if no shop model" do
    run_generator
    assert_file "app/controllers/authenticated_controller.rb" do |file|
      refute_match "def current_shop", file
    end
  end

  test "adds current_shop helper if shop model present" do
    ShopifyApp::Generators::ControllersGenerator.any_instance.stubs(:host_has_shop_model?).returns(true)

    run_generator
    assert_file "app/controllers/authenticated_controller.rb" do |file|
      assert_match "def current_shop", file
    end
  end

end
