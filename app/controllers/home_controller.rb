# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :require_login, only: [:show]

  def show; end

  private

  def require_login
    redirect_to login_path unless session[:user_id]
  end
end
