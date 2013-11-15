require 'spec_helper'

describe "spokes/edit" do
  before(:each) do
    @spoke = assign(:spoke, stub_model(Spoke,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit spoke form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", spoke_path(@spoke), "post" do
      assert_select "input#spoke_name[name=?]", "spoke[name]"
      assert_select "input#spoke_description[name=?]", "spoke[description]"
    end
  end
end
