require 'spec_helper'


describe 'posts/_post.html.haml' do
  fixtures :posts
  fixtures :spokes
  fixtures :users

  before do
    stub_template 'shared/_votable_item' => 'vote stuff'
    stub_template 'posts/_favorite_post' => 'favorite button'
    stub_template 'posts/_inappropriate_post' => 'inappropriate button'
  end

  let(:text_post) { posts(:post_three) }
  let(:link_post) { posts(:link_post_one) }

  context 'post is a link' do
    before do
      render 'posts/post', post: link_post
    end

    it 'has a div tag with class "post-type-link"' do
      expect(rendered).to include "<div class='post-type-link'"
      expect(rendered).to_not include "<div class='post-type-text'"
    end

    it 'has a link to the target of the link as the title of the post' do
      expect(rendered).to include link_to(link_post.title, link_post.content)
    end

    it 'makes the content into a link' do
      expect(rendered).
        to include %[<a href="#{link_post.content}" rel="nofollow">#{link_post.content}]
    end
  end

  context 'post is not a link' do
    before do
      render 'posts/post', post: text_post
    end

    it 'has a div tag with class "post-type-text"' do
      expect(rendered).to include "<div class='post-type-text'"
      expect(rendered).to_not include "<div class='post-type-link'"
    end

    it 'has a link to the target of the link' do
      expect(rendered).to include link_to(text_post.title,
        spoke_post_path(text_post.spoke.slug, text_post))
    end

    it 'makes a link in the content into a link' do
      expect(rendered).
        to include %[<a href="http://turtles.com" rel="nofollow">http://turtles.com]
    end
  end
end
