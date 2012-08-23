require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "#name returns the first_name and last_name as a String" do
    bob = users(:bob)
    assert_equal(bob.name, "Bob Uecker")
  end
end
