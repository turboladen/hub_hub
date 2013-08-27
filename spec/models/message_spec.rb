require 'spec_helper'

describe Message do
  describe '#initialize' do
    describe 'email' do
      it 'must not be empty' do
        expect(Message.new).to have(1).error_on(:email)
        expect(Message.new.errors_on(:email)).to include "can't be blank"
      end
    end

    describe 'name' do
      it 'must not be empty' do
        expect(Message.new).to have(1).error_on(:name)
        expect(Message.new.errors_on(:name)).to include "can't be blank"
      end
    end

    describe 'subject' do
      it 'must not be empty' do
        expect(Message.new).to have(1).error_on(:subject)
        expect(Message.new.errors_on(:subject)).to include "can't be blank"
      end
    end

    describe 'body' do
      it 'must not be empty' do
        expect(Message.new).to have(1).error_on(:body)
        expect(Message.new.errors_on(:body)).to include "can't be blank"
      end
    end
  end
end
