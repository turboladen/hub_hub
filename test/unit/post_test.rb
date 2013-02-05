require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @one = posts(:post_one)
    @two = posts(:post_two)
    @three = posts(:post_three)
    @four = posts(:post_four)
    @five = posts(:post_five)
    @link_post_one = posts(:link_post_one)
    @fresno_spoke = spokes(:fresno)
  end

  test "post attributes must not be empty" do
    post = Post.new
    assert post.invalid?
    assert post.errors[:title].any?
    assert post.errors[:content].any?
  end

  test "title can't be longer than 100 chars" do
    post = Post.new(content: "content", title: "1" * 100)
    post.spoke = @fresno_spoke
    assert post.save
    assert post.errors[:title].empty?

    post = Post.new(content: "content", title: "1" * 101)
    post.spoke = @fresno_spoke
    assert !post.save
    assert_equal "is too long (maximum is 100 characters)", post.errors[:title].join('; ')
  end

  test "title can't be shorter than 2 chars" do
    post = Post.new(content: "content", title: "12")
    post.spoke = @fresno_spoke
    assert post.save
    assert post.errors[:title].empty?

    post = Post.new(content: "content", title: "1")
    post.spoke = @fresno_spoke
    assert !post.save
    assert_equal "is too short (minimum is 2 characters)", post.errors[:title].join('; ')
  end


  test "content can't be longer than 4000 chars" do
    post = Post.new(content: "c" * 4000, title: "123")
    post.spoke = @fresno_spoke
    assert post.save
    assert post.errors[:content].empty?

    post = Post.new(content: "c" * 4001, title: "123")
    post.spoke = @fresno_spoke
    assert !post.save
    assert_equal "is too long (maximum is 4000 characters)", post.errors[:content].join('; ')
  end

  test "must belong to a spoke" do
    post = Post.new(content: "c", title: "123")
    post.spoke = @fresno_spoke
    assert post.save
    assert post.errors[:spoke_id].empty?

    post = Post.new(content: "c", title: "123")
    assert !post.save
    assert_equal "can't be blank", post.errors[:spoke_id].join('; ')
  end

  test "#most_active returns only posts with comments" do
    assert !Post.most_active.include?(@four)
    assert !Post.most_active.include?(@five)
  end

  test "#most_active returns posts ordered by comment count" do
    assert_equal Post.most_active, [@two, @three, @one]
  end

  test "#most_negative returns only posts with downvotes" do
    assert !Post.most_negative.include?(@one)
    assert !Post.most_negative.include?(@five)
  end

  test "#most_negative returns posts ordered by downvotes" do
    assert_equal Post.most_negative, [@three, @two, @four]
  end

  test "#most_positive returns only posts with upvotes" do
    assert !Post.most_positive.include?(@three)
    assert !Post.most_positive.include?(@five)
  end

  test "#most_positive returns posts ordered by upvotes" do
    assert_equal Post.most_positive, [@one, @two, @four]
  end

  test "#most_voted returns only posts with votes" do
    assert !Post.most_voted.include?(@five)
  end

  test "#most_voted returns posts ordered by total votes" do
    assert_equal Post.most_voted, [@two, @three, @one, @four]
  end

  test "#link? returns true for valid links" do
    assert_equal @link_post_one.link?, true
    assert_equal @one.link?, false
  end

  test "#item_type equals 'post'" do
    assert_equal @one.item_type, 'post'
  end

  test "allows tweeting post" do
    Twitter.expects(:update).with %Q{#{@one.spoke.name}: #{@one.title} test_url}
    @one.tweet('test_url')
  end

  test "allows sorting by newest" do
    sorted_posts = Post.newest
    assert_equal @link_post_one, sorted_posts[0]
    assert_equal @five, sorted_posts[1]
    assert_equal @four, sorted_posts[2]
    assert_equal @three, sorted_posts[3]
    assert_equal @two, sorted_posts[4]
    assert_equal @one, sorted_posts[5]
  end

  test "allows sorting by most active" do
    sorted_posts = Post.most_active
    assert_equal @two, sorted_posts[0]
    assert_equal @three, sorted_posts[1]
    assert_equal @one, sorted_posts[2]
    assert_nil sorted_posts[3]
    assert_nil sorted_posts[4]
    assert_nil sorted_posts[5]
  end

  test "allows sorting by most negative" do
    sorted_posts = Post.most_negative
    assert_equal @three, sorted_posts[0]
    assert_equal @two, sorted_posts[1]
    assert_equal @four, sorted_posts[2]
    assert_nil sorted_posts[3]
    assert_nil sorted_posts[4]
    assert_nil sorted_posts[5]
  end

  test "allows sorting by most positive" do
    sorted_posts = Post.most_positive
    assert_equal @one, sorted_posts[0]
    assert_equal @two, sorted_posts[1]
    assert_equal @four, sorted_posts[2]
    assert_nil sorted_posts[3]
    assert_nil sorted_posts[4]
    assert_nil sorted_posts[5]
  end

  test "allows sorting by most voted" do
    sorted_posts = Post.most_voted
    assert_equal @two, sorted_posts[0]
    assert_equal @three, sorted_posts[1]
    assert_equal @one, sorted_posts[2]
    assert_equal @four, sorted_posts[3]
    assert_nil sorted_posts[4]
    assert_nil sorted_posts[5]
  end

  test "get posts from last 24 hours" do
    sleep 0.5
    assert_equal 5, Post.last_24_hours.count
    assert_not_include Post.last_24_hours, @one
  end
end
