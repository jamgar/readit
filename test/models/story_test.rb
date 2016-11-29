require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  test "is not vailid without a name" do
    s = Story.create(
      name: nil,
      link: 'http://www.example.com/'
    )
    assert s.errors[:name].any?
    refute s.valid?
  end

  test "is not valid without a link" do
    s = Story.create(
      name: 'My test submission',
      link: nil
    )
    assert s.errors[:link].any?
    refute s.valid?
  end

  test "is valid with required attributes" do
    s = users(:glenda).stories.create(
      name: 'My test submission',
      link: 'http://www.example.com/'
    )
    assert s.valid?
  end

  test "returns highest vote first" do
    highest_id = stories(:one).votes.map(&:id).max
    assert_equal highest_id, stories(:one).votes.latest.first.id
  end

  test "return 3 latest votes" do
    10.times { stories(:one).votes.create(user: users(:glenda)) }
    assert_equal 3, stories(:one).votes.latest.size
  end

  test "is associated with a user" do
    assert_equal users(:glenda), stories(:one).user
  end

  test "increments vote counter cache" do
    stories(:two).votes.create(user: users(:glenda))
    stories(:two).reload
    assert_equal 1, stories(:two).attributes['votes_count']
  end

  test "decrements votes couter cache" do
    stories(:one).votes.first.destroy
    stories(:one).reload
    assert_equal 1, stories(:one).attributes['votes_count']
  end

  test "casts votes after creating story" do
    s = Story.create(
      name: "Vote SmartThe 2008 Elections",
      link: "http://votesmart.org",
      user: users(:glenda)
    )
    assert_equal users(:glenda), s.votes.first.user
  end

  test "is taggable" do
    stories(:one).tag_list = 'blog, ruby'
    stories(:one).save
    assert_equal 2, stories(:one).tags.size
    assert_equal [ 'blog', 'ruby' ], stories(:one).tag_list
  end

  test "finds tagged with" do
    stories(:one).tag_list = 'blog, ruby'
    stories(:one).save
    assert_equal [ stories(:one) ], Story.tagged_with('blog')
  end
end
