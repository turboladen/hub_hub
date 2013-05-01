require 'spec_helper'


describe 'shared/_spoke_list.html.haml' do
  fixtures :spokes

  context 'current page is home' do
    before do
      view.should_receive(:current_page?).with('/').and_return true
    end

    it 'makes the home page list item active' do
      render partial: 'shared/spoke_list'

      expect(rendered).to match %r[<li class='active spoke'>.*Home\n</a></li]m
    end
  end

  context 'current page is not home' do
    before do
      view.should_receive(:current_page?).with('/').and_return false
      view.stub_chain(:request, :fullpath).and_return '/spokes/fresno'
    end

    it 'makes the home page list item active' do
      render partial: 'shared/spoke_list'

      expect(rendered).to match %r[<li>.*Home\n</a></li]m
      expect(rendered).to match %r[<li class='active spoke'>.*Fresno\n</a></li]m
    end
  end
end
