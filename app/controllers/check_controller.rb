class CheckController < ApplicationController
  def index
    if VerifyCode.is_verify?(params[:code])
      render :status => 200, :text => 200
    else
      render :status => 411, :text => 411
    end
  end

end