require 'spec_helper'

describe Response do
  subject { FactoryGirl.build :response }

  it { should respond_to :body }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }
  it { should respond_to :owner }
  it { should respond_to :respondable }
  it { should respond_to :responses }

  describe 'body' do
    it 'must not be empty' do
      expect(Response.new.errors_on(:body)).to include "can't be blank"
    end

    it 'must be less than 4000 chars long' do
      body = 'a' * 4001
      expect(Response.new(body: body).errors_on(:body)).to include 'is too long (maximum is 4000 characters)'
    end
  end

  describe 'respondable' do
    it 'must not be empty' do
      expect(Response.new.errors_on(:respondable)).to include "can't be blank"
    end
  end

  describe 'owner' do
    it 'must not be empty' do
      expect(Response.new.errors_on(:owner)).to include "can't be blank"
    end
  end
end
