require 'spec_helper'

describe Spoke do
  it { should respond_to :name }
  it { should respond_to :description }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

  describe 'name' do
    it 'must not be empty' do
      expect(Spoke.new).to have(1).error_on(:name)
      expect(Spoke.new.errors_on(:name)).to include "can't be blank"
    end
  end
end
