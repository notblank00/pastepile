# frozen_string_literal: true

# Users Controller controls user data
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :check_if_editing_admin, only: %i[edit update destroy]
  before_action :check_admin_permission, only: :index
  before_action :check_admin_or_self_permission, except: %i[index new create]
  skip_before_action :authenticate, only: %i[new create]
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html do
          flash[:notice] = t('forms.messages.registration_successful')
          if session[:current_user_id]
            redirect_to users_path
          else
            sign_in @user
          end
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          flash[:notice] = t('forms.messages.user_was_successfully_updated')
          redirect_to @user
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:notice] = t('forms.messages.user_was_successfully_destroyed')
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def check_if_editing_admin
    refuse_with_method_not_allowed if @user.admin && !(current_user.id == @user.id) && !current_user.superuser
  end

  # Only allow a list of trusted parameters through.
  def user_params
    if current_user&.superuser
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin, :superuser)
    else
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  end

  def check_admin_permission
    refuse_with_method_not_allowed unless current_user.admin
  end

  def check_admin_or_self_permission
    refuse_with_method_not_allowed unless current_user.admin || current_user.id == params[:id].to_i
  end
end
