class CheckController < ApplicationController
  def index
    ip = request.remote_ip
    if VerifyCode.is_verify?(params[:code], ip)
      render :status => 200, :text => 200
    else
      render :status => 411, :text => 411
    end
  end

end