require 'spec_helper'

describe Spoke do
  it { should respond_to :name }
  it { should respond_to :description }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

  describe 'name' do
    subject { Spoke.new }

    it 'must not be empty' do
      expect(subject).to have(1).error_on(:name)
      expect(subject.errors_on(:name)).to include "can't be blank"
    end

    it 'must be unique' do
      FactoryGirl.create :spoke, name: 'test'
      subject.update(name: 'test')
      expect(subject).to have(1).error_on(:name)
      expect(subject.errors_on(:name)).to include 'has already been taken'
    end
  end
end
