require 'spec_helper'

describe User do
  context 'core attributes' do
    it { should respond_to :username }
    it { should respond_to :email }
    it { should respond_to :first_name }
    it { should respond_to :last_name }
    it { should respond_to :admin }
    it { should respond_to :banned }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }
  end

  context 'sorcery attributes' do
    it { should respond_to :password }
    it { should respond_to :password= }
    it { should respond_to :password_confirmation }
    it { should respond_to :password_confirmation= }
    it { should respond_to :crypted_password }
    it { should respond_to :salt }
    it { should respond_to :reset_password_token }
    it { should respond_to :reset_password_token_expires_at }
    it { should respond_to :reset_password_email_sent_at }
    it { should respond_to :remember_me_token }
    it { should respond_to :remember_me_token_expires_at }
    it { should respond_to :last_login_at }
    it { should respond_to :last_logout_at }
    it { should respond_to :last_activity_at }
    it { should respond_to :last_login_from_ip_address }
  end

  context 'associations' do
    it { should respond_to :posts }
  end

  describe '#username' do
    it 'must be present' do
      expect(User.new.errors_on(:username)).to include "can't be blank"
    end

    it 'must be unique' do
      FactoryGirl.create :user, username: 'test_user'
      subject.update(username: 'test_user')
      expect(subject).to have(1).error_on(:username)
      expect(subject.errors_on(:username)).to include 'has already been taken'
    end
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
