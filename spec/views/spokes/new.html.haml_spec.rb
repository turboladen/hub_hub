require 'spec_helper'

describe "spokes/new" do
  before(:each) do
    assign(:spoke, stub_model(Spoke,
      :name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new spoke form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", spokes_path, "post" do
      assert_select "input#spoke_name[name=?]", "spoke[name]"
      assert_select "input#spoke_description[name=?]", "spoke[description]"
    end
  end
end
