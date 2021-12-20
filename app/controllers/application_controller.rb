# frozen_string_literal: true

# This is the base controller for the app
class ApplicationController < ActionController::Base
  before_action :authenticate
  before_action :set_current_user

  def current_user
    User.find(session[:current_user_id])
  rescue StandardError
    nil
  end

  def set_current_user
    @current_user = current_user
  end

  private

  def authenticate
    redirect_to signin_path unless current_user
  end

  def refuse_with_method_not_allowed
    respond_to do |format|
      format.all { render html: File.read('public/405.html').html_safe, status: :method_not_allowed }
    end
  end
end
