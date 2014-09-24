require 'test_helper'

module AccessControl
  class HomeControllerTest < ActionController::TestCase

     test "the truth" do
       sut = HomeController.new
       sut.index
       assert true
     end

  end
end
