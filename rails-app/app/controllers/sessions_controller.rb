class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    email    = params[:session][:email]
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインしました'
      redirect_to posts_path
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success]   = 'ログアウトしました'
    redirect_to login_url
  end

  private

  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id
      return true
    else
      return false
    end
  end
end
