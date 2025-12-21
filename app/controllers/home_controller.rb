class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to dashboard_path
    else
    end
  end

  def about
  end

  def contact
  end
end