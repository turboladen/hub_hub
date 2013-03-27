require 'test_helper'


class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:post_one)
  end

  test 'shows post' do
    get :show, id: @post, spoke_id: @post.spoke.id

    assert_equal assigns(:post), @post
    assert_response :success
    assert_select 'title', "MindHub Post: #{@post.title}"
    assert_select '.breadcrumb li', @post.spoke.name
    assert_select 'h1', @post.title
    assert_select '.span9 div p time'
    assert_select '.span9 div p', /#{@post.user_name}/
    assert_select '.span9 .well p', @post.content
    assert_select 'td.comment', @post.comment_threads.count

    assert_select 'ul.nav.nav-list', 1 do
      assert_select 'li.active.spoke', 1 do
        assert_select 'a', 1
      end

      assert_select 'li.spoke', 1 do
        assert_select 'a', 1
      end
    end
  end

  test 'shows post with http:// reference and linkifies it' do
    post = posts(:post_three)
    get :show, id: post, spoke_id: post.spoke.id

    assert_match '<a href="http://turtles.com"', @response.body
  end

  test 'shows post with no link to edit when not logged in' do
    test_shows_post
    assert_select '.span9 div p a', false
  end

  test 'shows post with no link to edit when logged in as not post creator' do
    sign_in users(:ricky)
    test_shows_post
    assert_select '.span9 div p a', false
  end

  test 'shows post with link to edit when logged in as post creator' do
    sign_in users(:bob)
    test_shows_post
    assert_select '.span9 div p a', 'Edit'
  end
end
