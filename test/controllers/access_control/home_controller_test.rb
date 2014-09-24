require 'test_helper'

module AccessControl
  class HomeControllerTest < ActionController::TestCase

     test "index is defined" do
       assert HomeController.new.respond_to?('index')
     end

    test "chair is not defined" do
      assert_not HomeController.new.respond_to?('chair')
    end

  end
end
