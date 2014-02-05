require 'spec_helper'

describe User do
  context 'core attributes' do
    it { should respond_to :email }
    it { should respond_to :first_name }
    it { should respond_to :last_name }
    it { should respond_to :admin }
    it { should respond_to :banned }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }
  end

  context 'auth attributes' do
    it { should respond_to :password_digest }
    it { should respond_to :password }
    it { should respond_to :password_confirmation }
    it { should respond_to :authenticate }
    it { should respond_to :remember_token }
  end

  context 'associations' do
    it { should respond_to :posts }
    it { should respond_to :responses }
  end

  describe '#email' do
    it 'must be present' do
      expect(User.new.errors_on(:email)).to include "can't be blank"
    end

    it 'must be unique' do
      FactoryGirl.create :user, email: 'test_user@example.com'
      subject.update(email: 'test_user@example.com')
      expect(subject).to have(1).error_on(:email)
      expect(subject.errors_on(:email)).to include 'has already been taken'
    end
  end

  describe '#password' do
    it 'must be present on create' do
      expect(User.new.errors_on(:password)).to include "can't be blank"
    end

    it 'must match the confirmation' do
      user = FactoryGirl.build :user, password_confirmation: 'bad password'
      expect(user).to_not be_valid
    end

    it 'must be at least 6 characters long' do
      user = FactoryGirl.build :user, password: '12345', password_confirmation: '12345'
      expect(user.errors_on(:password)).to include 'is too short (minimum is 6 characters)'
    end
  end

  describe '#authenticate' do
    let!(:user) { FactoryGirl.create :user }
    let(:found_user) { User.find_by email: user.email }

    context 'with valid password' do
      it 'returns the User object' do
        expect(found_user.authenticate('password')).to eq user
      end
    end

    context 'with ivalid password' do
      it 'returns false' do
        expect(found_user.authenticate('bad password')).to eq false
      end
    end
  end

  describe '#banned' do
    it 'defaults to false' do
      expect(User.new.banned).to eq false
    end
  end

  describe '#admin' do
    it 'defaults to false' do
      expect(User.new.admin).to eq false
    end
  end
end
