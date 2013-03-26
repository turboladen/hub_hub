require 'spec_helper'


describe 'spokes/show.html.haml' do
  fixtures :spokes

  let(:spoke) { spokes(:fresno) }

  before do
    stub_template 'spokes/_sort_options' => 'newest'
    stub_template 'posts/_post' => 'post-in-list '
    stub_template 'shared/_pager' => 'pagination stuff'
    stub_template 'spokes/_spoke_info' => 'spoke list'

    assign(:spoke, spoke)
    assign(:sorter, :newest)
    assign(:posts, spoke.posts)
  end

  context 'user not signed in' do
    before do
      view.stub(:user_signed_in?).and_return false
    end

    it 'includes data-content to login to start posting' do
      render

      expect(rendered).to include 'Login to start posting in this spoke.'
      expect(rendered).to include 'Create Post'
      expect(rendered).to include 'Add Link'
      expect(rendered).to include('post-in-list ' * spoke.posts.count)
      expect(rendered).to include 'pagination stuff'
    end
  end

  context 'user signed in' do
    before do
      view.stub(:user_signed_in?).and_return true
    end

    it 'includes data-content to login to start posting' do
      render

      expect(rendered).to_not include 'Login to start posting in this spoke.'
      expect(rendered).to include 'Create Post'
      expect(rendered).to include 'Add Link'
      expect(rendered).to include('post-in-list ' * spoke.posts.count)
      expect(rendered).to include 'pagination stuff'
    end
  end
end
