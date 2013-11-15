require 'spec_helper'

describe "spokes/show" do
  before(:each) do
    @spoke = assign(:spoke, stub_model(Spoke,
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Description/)
  end
end
