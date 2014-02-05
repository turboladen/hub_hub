require 'spec_helper'

describe Post do
  it { should respond_to :title }
  it { should respond_to :body }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

  it { should respond_to :owner }
  it { should respond_to :spoke }
  it { should respond_to :responses }

  describe 'title' do
    it 'must not be empty' do
      expect(Post.new.errors_on(:title)).to include "can't be blank"
    end

    it 'must be at least 2 chars long' do
      expect(Post.new.errors_on(:title)).to include 'is too short (minimum is 2 characters)'
    end

    it 'must be less than 100 chars long' do
      title = 'a' * 101
      expect(Post.new(title: title).errors_on(:title)).to include 'is too long (maximum is 100 characters)'
    end
  end

  describe 'body' do
    it 'must not be empty' do
      expect(Post.new.errors_on(:body)).to include "can't be blank"
    end

    it 'must be less than 4000 chars long' do
      body = 'a' * 4001
      expect(Post.new(body: body).errors_on(:body)).to include 'is too long (maximum is 4000 characters)'
    end
  end

  describe 'spoke' do
    it 'must not be empty' do
      expect(Post.new.errors_on(:spoke)).to include "can't be blank"
    end
  end
end
