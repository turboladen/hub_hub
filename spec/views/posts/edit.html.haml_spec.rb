require 'spec_helper'

describe 'posts/edit' do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :title => 'MyString',
      :body => 'MyText',
      :user => nil,
      :spoke => nil,
      :cached_votes_total => 1,
      :cached_votes_up => 1,
      :cached_votes_down => 1
    ))
  end

  it 'renders the edit post form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', post_path(@post), 'post' do
      assert_select 'input#post_title[name=?]', 'post[title]'
      assert_select 'textarea#post_body[name=?]', 'post[body]'
      assert_select 'input#post_user[name=?]', 'post[user]'
      assert_select 'input#post_spoke[name=?]', 'post[spoke]'
      assert_select 'input#post_cached_votes_total[name=?]', 'post[cached_votes_total]'
      assert_select 'input#post_cached_votes_up[name=?]', 'post[cached_votes_up]'
      assert_select 'input#post_cached_votes_down[name=?]', 'post[cached_votes_down]'
    end
  end
end
