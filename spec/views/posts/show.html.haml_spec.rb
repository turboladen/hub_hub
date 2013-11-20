require 'spec_helper'

describe 'posts/show' do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :title => 'Title',
      :body => 'MyText',
      :user => nil,
      :spoke => nil,
      :cached_votes_total => 1,
      :cached_votes_up => 2,
      :cached_votes_down => 3
    ))
  end

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
