require 'test_helper'


class HomeControllerTest < ActionController::TestCase
  fixtures :spokes
  fixtures :posts

  def renders_spoke_sidebar
    assert_select 'ul.nav.nav-list', 1 do
      assert_select 'li.active.spoke', 1 do
        assert_select 'a', 1
      end

      assert_select 'li.spoke', 1 do
        assert_select 'a', 1
      end
    end
  end

  test 'gets index' do
    get :index

    assert_not_nil assigns(:posts)

    assert_response :success
    assert_select 'td .post-title', 6
    renders_spoke_sidebar
  end

  test 'gets index with sorter' do
    get :index, sort: :newest

    assert_response :success
    assert_equal assigns(:posts).size, 6
    renders_spoke_sidebar
    assert_select 'div .post-title', 6
  end

  test 'gets terms of service' do
    get :tos

    assert_response :success
    assert_template 'home/tos'
  end

  test 'gets the faq' do
    get :faq

    assert_response :success
    assert_template 'home/faq'
  end
end
