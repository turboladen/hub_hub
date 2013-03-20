require 'test_helper'


class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:post_one)
  end

  test 'does not create post when not logged in' do
    assert_no_difference('Post.count') do
      post :create, spoke_id: @post.spoke.id, post: {
        title: "I'm not logged in",
        content: "So this shouldn't work."
      }
    end

    assert_response 302
    assert_redirected_to new_user_session_url
  end

  test 'creates post when logged in' do
    sign_in users(:ricky)
    Post.any_instance.expects(:tweet)

    assert_difference('Post.count') do
      post :create, spoke_id: @post.spoke.id, post: {
        title: "I'm logged in",
        content: 'So this should work.'
      }
    end

    assert_equal assigns(:spoke), @post.spoke
    assert_not_nil assigns(:post)
    assert_equal assigns(:post).user, users(:ricky)
    assert_response 302
    assert_redirected_to spoke_path(@post.spoke)
  end

  test 'tweets after successfully creating post' do
    Post.any_instance.expects(:tweet)
    sign_in users(:ricky)

    post :create, spoke_id: @post.spoke.id, post: {
      title: "I'm logged in",
      content: 'So this should work.'
    }

    assert_equal 'Your post was created.', flash[:notice]
  end

  test 'shows post' do
    get :show, id: @post, spoke_id: @post.spoke.id

    assert_equal assigns(:post), @post
    assert_response :success
    assert_select 'title', "MindHub Post: #{@post.title}"
    assert_select '.breadcrumb li', @post.spoke.name
    assert_select 'h1', @post.title
    assert_select '.span9 div p time'
    assert_select '.span9 div p', /#{@post.user.name}/
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

  test 'does not show edit page when not logged in' do
    get :edit, id: @post.id, spoke_id: @post.spoke.id

    assert_response 302
    assert_redirected_to new_user_session_url
  end

  test 'does not show edit page when not logged in as post creator' do
    sign_in users(:ricky)
    get :edit, id: @post.id, spoke_id: @post.spoke.id

    assert_response 302
    assert_redirected_to spoke_post_url(@post.spoke.id, @post)
    assert_equal 'You must have created the post to be able to edit it.',
      flash[:notice]
  end

  test 'shows edit page when logged in as post creator' do
    sign_in users(:bob)
    get :edit, id: @post.id, spoke_id: @post.spoke.id

    assert_equal assigns(:post), @post
    assert_response 200
  end

  test 'does not allow flag via JS when not logged in' do
    put :flag, post_id: @post.id, spoke_id: @post.spoke.id, format: :js

    assert_response 401
  end

  test 'does not allow flag via HTML when not logged in' do
    put :flag, post_id: @post.id, spoke_id: @post.spoke.id, format: :html

    assert_response 302
    assert_redirected_to new_user_session_url
  end

  test 'allows flag when not logged in as post owner' do
    sign_in users(:ricky)
    put :flag, post_id: @post.id, spoke_id: @post.spoke.id, flag_type: :inappropriate,
      format: :js

    assert_equal assigns(:flag_type), :inappropriate
    assert_response 200
    assert_template 'posts/flag'
  end

  test 'allows flag when logged in as post owner' do
    sign_in users(:bob)
    put :flag, post_id: @post.id, spoke_id: @post.spoke.id, flag_type: :inappropriate,
      format: :js

    assert_equal assigns(:flag_type), :inappropriate
    assert_response 200
    assert_template 'posts/flag'
  end
end
