class Admin::MessageController < ApplicationController
  layout 'admin'
  before_filter :ensure_admin

  # GET admin/messages/new
  def new
    @message = Message.new(email: User.super_user, name: 'MindHub Admin')
  end

  # POST admin/message/create
  def create
    @message = Message.new(params[:message])
    @message.email = User.super_user.email
    @message.name = 'MindHub Admin'

    if @message.valid?
      NotificationsMailer.new_message(@message).deliver
      redirect_to(admin_path, notice: 'Message was successfully sent.')
    else
      flash[:error] = 'Please fill in all fields.'
      render :new
    end
  end
end
