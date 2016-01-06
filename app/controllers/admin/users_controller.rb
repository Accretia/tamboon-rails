class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = @app.all_users
  end

  def new
    @user = @app.user
  end

  def create
    @charity = @app.create_charity(charity_params)

    if @charity.persisted?
      flash.notice = t(".success")
      redirect_to admin_charities_path
    else
      flash.alert = t(".failure")
      render :new
    end
  end

  def edit
      @user = @app.find_user(params[:id])
      #@user = @app.find_user(id)
      render :edit
  end


  private

  def charity_params
    params.require(:charity).permit(:name, :description)
  end
end
