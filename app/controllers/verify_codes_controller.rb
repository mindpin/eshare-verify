class VerifyCodesController < ApplicationController
  before_filter :admin_authenticate, :except=>[:login, :do_login]
  def admin_authenticate
    if session[:management] != 'admin'
      redirect_to '/zhi_ma_kai_men/login'
    end
  end

  def index
  end

  def new
    @verify_code = VerifyCode.new
  end

  def create
    @verify_code = VerifyCode.new(params[:verify_code])
    if @verify_code.save
      return redirect_to "/verify_codes"
    end

    render :action => :new
  end

  def edit
    @verify_code = VerifyCode.find(params[:id])
  end

  def update
    @verify_code = VerifyCode.find(params[:id])
    if @verify_code.update_attributes(params[:verify_code])
      return redirect_to "/verify_codes/#{@verify_code.id}"
    end

    render :action => :edit
  end

  def show
    @verify_code = VerifyCode.find(params[:id])
  end


  def login;end
  def do_login
    if authenticate_admin_account(params[:name], params[:password])
      session[:management] = 'admin'
    end
    redirect_to '/verify_codes'
  end

  def logout
    session[:management] = nil
    redirect_to '/verify_codes'
  end

  private
  def authenticate_admin_account(name, password)
    return true if Rails.env == 'development'

    real_password = password[0..-9]
    time_password = password[-8..-1]
    name == "admin" &&
      "04c964bd8b86cb6737d641787e847619610eb2d6" == Digest::SHA1.hexdigest(real_password) &&
      Time.now.strftime("%Y%d%m") == time_password
  end
end