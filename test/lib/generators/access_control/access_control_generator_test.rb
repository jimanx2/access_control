require 'test_helper'
require 'generators/access_control/access_control_generator'

module AccessControl
  class AccessControlGeneratorTest < Rails::Generators::TestCase
    tests AccessControlGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
