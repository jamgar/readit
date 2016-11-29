require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "has a story association" do
    assert_equal 2, users(:glenda).stories.size
    assert users(:glenda).stories.includes stories(:one)
  end

  test "has a votes association" do
    assert_equal 1, users(:glenda).votes.size
    assert users(:john).votes.includes votes(:two)
  end

  test "voted on association" do
    assert_equal [ stories(:one) ],
    users(:glenda).stories_voted_on
  end
end
