class Admin::SettingsController < ApplicationController
  layout "admin"
  before_filter :ensure_admin

  def index
    @settings = Settings.digest_email
  end

  def create
    @send_time = params[:send_time]
    Settings.digest_email[:send_time] = @send_time

    render 'admin/settings/index'
  end
end
