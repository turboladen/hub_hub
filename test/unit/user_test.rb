require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @bob = users(:bob)
  end

  test "#name returns the first_name and last_name as a String" do
    assert_equal(@bob.name, "Bob Uecker")
  end

  test "user is not admin by default" do
    assert_equal(@bob.admin?, false)
  end
end
