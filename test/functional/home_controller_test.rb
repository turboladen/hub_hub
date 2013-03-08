require 'test_helper'


class HomeControllerTest < ActionController::TestCase
  fixtures :posts

  test 'gets index' do
    get :index

    assert_not_nil assigns(:posts)
    assert_equal assigns(:sort_options), Post.sort_options
    assert_not_nil assigns(:spokes)

    assert_response :success
    assert_select 'li .spoke', 2
    assert_select 'td .post-title', 6
  end

  test 'gets index with sorter' do
    get :index, sort: :newest

    assert_response :success
    assert_equal assigns(:posts).size, 6
    assert_select 'li .spoke', 2
    assert_select 'div .post-title', 6
  end

  test 'gets terms of service' do
    get :tos

    assert_response :success
    assert_template 'home/tos'
  end
end
