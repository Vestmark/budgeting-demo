class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:email]&.downcase)

    if @user&.authenticate(params[:password])
      login @user
      redirect_to root_path, notice: "Welcome back!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: "Logged out successfully"
  end
end
