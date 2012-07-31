require 'test_helper'

class SpokeTest < ActiveSupport::TestCase
  test "spoke attributes must not be empty" do
    spoke = Spoke.new
    assert spoke.invalid?
    assert spoke.errors[:name].any?
  end
end
