require 'spec_helper'

describe User do
  it { should respond_to :email }
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :admin }
  it { should respond_to :banned }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }
  it { should respond_to :encrypted_password }
  it { should respond_to :reset_password_token }
  it { should respond_to :reset_password_sent_at }
  it { should respond_to :remember_created_at }
  it { should respond_to :sign_in_count }
  it { should respond_to :current_sign_in_at }
  it { should respond_to :last_sign_in_at }
  it { should respond_to :current_sign_in_ip }
  it { should respond_to :last_sign_in_ip }

  it { should respond_to :posts }
end
